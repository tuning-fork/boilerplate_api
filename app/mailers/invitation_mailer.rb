# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]
    mail to: @invitation.email,
         subject: "You've been invited to join #{@invitation.organization.name} on Boilerplate"
  end
end
