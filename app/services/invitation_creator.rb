# frozen_string_literal: true

class InvitationCreator
  def initialize(invitation_params, organization)
    @invitation_params = invitation_params
    @organization = organization
  end

  def call!
    invitation = find_or_create_invitation!
    generate_invitation_token!(invitation)

    InvitationMailer.with(invitation: invitation).invite.deliver_later

    Rails.logger.info("New invitation #{invitation} created")

    invitation
  end

  private

  attr_reader :invitation_params, :organization

  def find_or_create_invitation!
    invitation = Invitation.find_by(email: invitation_params[:email], organization_id: organization.id)
    return invitation if invitation.present?

    Invitation.create!(
      **invitation_params,
      organization: organization
    )
  end

  def generate_invitation_token!(invitation)
    token = SecureRandom.urlsafe_base64
    expires_at = 1.week.from_now.to_date
    invitation.update!(token: token, expires_at: expires_at)
  end
end
