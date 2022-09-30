# frozen_string_literal: true

# http://localhost:3000/rails/mailers/invitation_mailer/invite
class InvitationMailerPreview < ActionMailer::Preview
  def invite
    InvitationMailer.with(invitation: Invitation.last).invite
  end

  def invitation_accepted
    InvitationMailer.with(invitation: Invitation.last).invitation_accepted
  end
end
