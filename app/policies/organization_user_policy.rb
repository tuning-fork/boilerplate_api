# frozen_string_literal: true

class OrganizationUserPolicy < ApplicationPolicy
  def destroy?
    user.admin_of_organization?(record.organization.id)
  end
end
