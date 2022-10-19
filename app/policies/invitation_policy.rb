# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  # `record` is slightly different depending on which action we're authorizing
  # * for index? and create?, record is an organization instance
  # * for accept?, record is the symbol :accept?
  # * for reinvite? and destroy?, record is an invitation instance

  def index?
    user.admin_of_organization?(record.id)
  end

  def create?
    user.admin_of_organization?(record.id)
  end

  def accept?
    true
  end

  def reinvite?
    user.admin_of_organization?(record.organization.id)
  end

  def destroy?
    user.admin_of_organization?(record.organization.id)
  end
end
