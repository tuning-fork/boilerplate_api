# frozen_string_literal: true

require 'rails_helper'

describe OrganizationUserPolicy do
  subject { described_class }

  permissions :destroy? do
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    it 'denies access if user is not in organization' do
      organization_user = OrganizationUser.new(user: create(:user), organization: organization)
      expect(subject).not_to permit(user, organization_user)
    end

    it 'denies access if user is not an admin in organization' do
      organization_user = OrganizationUser.new(user: create(:user), organization: organization)
      organization.organization_users << OrganizationUser.new(user: user, roles: [Organization::Roles::USER])
      expect(subject).not_to permit(user, organization_user)
    end

    it 'grants access if user is an admin in organization' do
      organization_user = OrganizationUser.new(user: create(:user), organization: organization)
      organization.organization_users << OrganizationUser.new(user: user, roles: [Organization::Roles::ADMIN])
      expect(subject).to permit(user, organization_user)
    end
  end
end
