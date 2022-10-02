# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]
    mail to: @invitation.email,
         subject: "You've been invited to join #{@invitation.organization.name} on Boilerplate"
  end

  def invitation_accepted
    @invitation = params[:invitation]
    mail to: @invitation.organization.admins.pluck(:email),
         subject: "New user added to your organization #{@invitation.organization.name} on Boilerplate"
  end
end
