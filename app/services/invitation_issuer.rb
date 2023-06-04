# frozen_string_literal: true

# Service for issuing a new invitiation or re-inviting an existing invitation if
# it has expired.
class InvitationIssuer
  def initialize(invitation_params, organization)
    @invitation_params = invitation_params
    @organization = organization
  end

  def call!
    invitation = find_or_create_invitation!
    generate_invitation_token!(invitation)

    InvitationMailer.with(invitation:).invite.deliver_later

    Rails.logger.info("Invitation #{invitation} issued")

    invitation
  end

  private

  attr_reader :invitation_params, :organization

  def find_or_create_invitation!
    invitation = Invitation.find_by(email: invitation_params[:email], organization_id: organization.id)
    return invitation if invitation.present?

    invitation = Invitation.create!(
      **invitation_params,
      organization:
    )
    Rails.logger.info("New invitation #{invitation} created")
    invitation
  end

  def generate_invitation_token!(invitation)
    token = SecureRandom.urlsafe_base64
    expires_at = 1.week.from_now.to_date
    invitation.update!(token:, expires_at:)
  end
end
