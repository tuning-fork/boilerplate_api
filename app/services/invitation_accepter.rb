# frozen_string_literal: true

class InvitationAccepter
  class InvalidTokenException < StandardError
    def message
      'Token is expired or invalid.'
    end
  end

  attr_accessor :invitation_token, :user_params

  def initialize(invitation_token, user_params)
    @invitation_token = invitation_token
    @user_params = user_params
  end

  def call!
    invitation = find_invitation!
    user_attrs = { **invitation.slice(%w[first_name last_name email]), **user_params }
    user = User.create!(user_attrs)
    invitation.update!(user: user)
    invitation.organization.users << user

    InvitationMailer.with(invitation: invitation).invitation_accepted.deliver_later

    Rails.logger.info("Invitation #{invitation} accepted")

    invitation
  end

  private

  def find_invitation!
    invitation = Invitation.find_by!(token: invitation_token)
    raise InvalidTokenException if invitation.expires_at.today? || invitation.expires_at.past?

    invitation
  rescue ActiveRecord::RecordNotFound
    raise InvalidTokenException
  end
end
