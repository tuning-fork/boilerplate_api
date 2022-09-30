# frozen_string_literal: true

require 'rails_helper'

describe InvitationMailer, type: :mailer do
  describe 'invite' do
    let(:invitation) { create(:invitation, token: 'abc123') }
    let(:mail) { InvitationMailer.with(invitation: invitation).invite }

    it 'renders the headers' do
      expect(mail.subject).to eq("You've been invited to join #{invitation.organization.name} on Boilerplate")
      expect(mail.to).to eq([invitation.email])
      expect(mail.from).to eq([ENV.fetch('ACTION_MAILER_GMAIL_ACCOUNT')])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{invitation.first_name}")
      expect(mail.body.encoded).to include(invitation.build_accept_link)
    end
  end

  describe 'invitation_accepted' do
    let(:invitation) { create(:invitation, :with_user) }
    let!(:admins) do
      invitation.organization.organization_users = [
        OrganizationUser.new(user: create(:user), roles: [Organization::Roles::ADMIN]),
        OrganizationUser.new(user: create(:user), roles: [Organization::Roles::USER]),
        OrganizationUser.new(user: create(:user), roles: [Organization::Roles::ADMIN])
      ]
      invitation.organization.admins
    end
    let(:mail) { InvitationMailer.with(invitation: invitation).invitation_accepted }

    it 'renders the headers' do
      expect(mail.subject).to eq("New user added to your organization #{invitation.organization.name} on Boilerplate")
      expect(mail.to).to eq(admins.pluck(:email))
      expect(mail.from).to eq([ENV.fetch('ACTION_MAILER_GMAIL_ACCOUNT')])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("#{invitation.user.first_name} #{invitation.user.last_name}")
    end
  end
end
