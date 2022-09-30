# frozen_string_literal: true

require 'rails_helper'

describe InvitationAccepter do
  let(:invitation) { create(:invitation) }
  let(:invitation_token) { invitation.token }
  let(:user_params) { { 'password' => 'the password' } }
  subject { InvitationAccepter.new(invitation_token, user_params) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#call!' do
    context 'when token is valid' do
      let!(:result) { subject.call! }

      it 'returns accepted invitation' do
        expect(result).to be_an_instance_of(Invitation)
        expect(result.organization.id).to eq(invitation.organization.id)
        expect(result.user.first_name).to eq(invitation.first_name)
      end

      it 'creates a user using invitation and user params' do
        params_to_share = %w[first_name last_name email]
        expect(User.last).not_to be(nil)
        expect(User.last.slice(params_to_share)).to eq(invitation.slice(params_to_share))
      end

      it 'adds user to invitation' do
        expect(Invitation.last.user).to eq(result.user)
      end

      it 'adds user to organization' do
        expect(invitation.organization.users).to include(result.user)
      end

      it 'schedules email to admin' do
        expect do
          # using different email to allow re-calling without "email already taken" error
          invitation.update!(email: 'different@email.com')
          subject.call!
        end.to have_enqueued_mail(InvitationMailer, :invitation_accepted)
      end
    end

    context 'when token expired today' do
      before do
        invitation.update!(expires_at: Date.current)
      end

      subject { InvitationAccepter.new(invitation.token, user_params) }

      it 'raises InvitationAccepter::InvalidTokenException' do
        expect do
          subject.call!
        end.to raise_error(InvitationAccepter::InvalidTokenException)
      end
    end

    context 'when token expired' do
      before do
        invitation.update!(expires_at: 1.day.ago)
      end

      subject { InvitationAccepter.new(invitation.token, user_params) }

      it 'raises InvitationAccepter::InvalidTokenException' do
        expect do
          subject.call!
        end.to raise_error(InvitationAccepter::InvalidTokenException)
      end
    end

    context 'when not invitation exists with token' do
      subject { InvitationAccepter.new('non-existent-token', user_params) }

      it 'raises InvitationAccepter::InvalidTokenException' do
        expect do
          subject.call!
        end.to raise_error(InvitationAccepter::InvalidTokenException)
      end
    end
  end
end
