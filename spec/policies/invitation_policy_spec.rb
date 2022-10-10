# frozen_string_literal: true

require 'rails_helper'

describe InvitationPolicy do
  subject { described_class }

  permissions :index? do
    it 'denies access if user is not in organization' do
      user = create(:user)
      organization = create(:organization)
      expect(subject).not_to permit(user, organization)
    end

    it 'denies access to invitations if user is not an admin in organization' do
      user = create(:user)
      organization = create(:organization)
      organization.organization_users = [
        OrganizationUser.new(user: user, roles: [Organization::Roles::USER])
      ]
      expect(subject).not_to permit(user, organization)
    end

    it 'grants access to invitations if user is an admin in organization' do
      user = create(:user)
      organization = create(:organization)
      organization.organization_users = [
        OrganizationUser.new(user: user, roles: [Organization::Roles::ADMIN])
      ]
      expect(subject).to permit(user, organization)
    end
  end
end
