# frozen_string_literal: true

require 'rails_helper'

describe InvitationCreator do
  subject { InvitationCreator.new(invitation_params, organization) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#call!' do
    let(:organization) { create(:organization) }
    let(:invitation_params) { { first_name: 'Elenor', last_name: 'Shellstrop', email: 'elenor@thegoodplace.org' } }
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
end
