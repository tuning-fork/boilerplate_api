# frozen_string_literal: true

require 'rails_helper'

describe InvitationMailer, type: :mailer do
  describe 'invite' do
    let(:invitation) { create(:invitation) }
    let(:mail) { InvitationMailer.with(invitation: invitation).invite }

    it 'renders the headers' do
      expect(mail.subject).to eq("You've been invited to join #{invitation.organization.name} on Boilerplate")
      expect(mail.to).to eq([invitation.email])
      expect(mail.from).to eq([ENV.fetch('ACTION_MAILER_GMAIL_ACCOUNT')])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{invitation.first_name}")
      expect(mail.body.encoded).to match(invitation.accept_link)
    end
  end
end
