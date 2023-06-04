# frozen_string_literal: true

require 'rails_helper'

describe InvitationIssuer do
  let(:organization) { create(:organization) }
  let(:invitation_params) { { first_name: 'Elenor', last_name: 'Shellstrop', email: 'elenor@thegoodplace.org' } }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#call!' do
    context 'when invitation does not exist' do
      subject { InvitationIssuer.new(invitation_params, organization) }
      let!(:result) { subject.call! }

      it 'returns created invitation' do
        expect(result).to be_instance_of(Invitation)
        expect(result.first_name).to eq('Elenor')
      end

      it 'creates an invitation using params' do
        expect(Invitation.last.first_name).to eq('Elenor')
      end

      it 'adds invitation to provided organization' do
        expect(organization.invitations).to include(result)
      end

      it 'generate a token for the invitation' do
        expect(Invitation.last.token).to be_instance_of(String)
      end

      it 'sets expiration date of token to a week from now' do
        expect(Invitation.last.expires_at).to eq(1.week.from_now.to_date)
      end

      it 'schedules email to user' do
        expect { subject.call! }.to have_enqueued_mail(InvitationMailer, :invite)
      end
    end

    context 'when invitation already exists' do
      let!(:existing_invitation) do
        create(:invitation, organization:, email: invitation_params[:email], expires_at: Date.current)
      end

      subject { InvitationIssuer.new(invitation_params, organization) }
      let!(:result) { subject.call! }

      it 'returns existing invitation' do
        expect(result).to eq(existing_invitation)
      end

      it 'does not create duplicate invitation' do
        expect(Invitation.count).to eq(1)
      end

      it 'does not create duplicate invitation association within organization' do
        expect(organization.invitations).to match_array([result])
      end

      it 'generate a new token to re-issue the invitation' do
        expect(result.token).to be_instance_of(String)
        expect(result.token).not_to eq(existing_invitation.token)
      end

      it 'sets expiration date of new token to a week from now' do
        expect(result.expires_at).not_to eq(existing_invitation.expires_at)
        expect(result.expires_at).to eq(1.week.from_now.to_date)
      end

      it 'schedules email to user' do
        expect { subject.call! }.to have_enqueued_mail(InvitationMailer, :invite)
      end
    end
  end
end
