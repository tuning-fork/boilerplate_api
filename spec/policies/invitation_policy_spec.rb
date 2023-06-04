# frozen_string_literal: true

require 'rails_helper'

describe InvitationPolicy do
  subject { described_class }

  permissions :index?, :create? do
    it 'denies access if user is not in organization' do
      user = create(:user)
      organization = create(:organization)
      expect(subject).not_to permit(user, organization)
    end

    it 'denies access if user is not an admin in organization' do
      user = create(:user)
      organization = create(:organization)
      organization.organization_users = [
        OrganizationUser.new(user:, roles: [Organization::Roles::USER])
      ]
      expect(subject).not_to permit(user, organization)
    end

    it 'grants access if user is an admin in organization' do
      user = create(:user)
      organization = create(:organization)
      organization.organization_users = [
        OrganizationUser.new(user:, roles: [Organization::Roles::ADMIN])
      ]
      expect(subject).to permit(user, organization)
    end
  end

  permissions :accept? do
    it 'grants access to anyone' do
      expect(subject).to permit(Invitation, :accept?)
    end
  end

  permissions :reinvite?, :destroy? do
    it 'denies access if user is not in organization' do
      user = create(:user)
      invitation = create(:invitation)
      expect(subject).not_to permit(user, invitation)
    end

    it 'denies access if user is not an admin in organization' do
      user = create(:user)
      invitation = create(:invitation)
      invitation.organization.organization_users = [
        OrganizationUser.new(user:, roles: [Organization::Roles::USER])
      ]
      expect(subject).not_to permit(user, invitation)
    end

    it 'grants access if user is an admin in organization' do
      user = create(:user)
      invitation = create(:invitation)
      invitation.organization.organization_users = [
        OrganizationUser.new(user:, roles: [Organization::Roles::ADMIN])
      ]
      expect(subject).to permit(user, invitation)
    end
  end
end
