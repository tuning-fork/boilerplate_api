# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  def index?
    user.admin?
    # user.admin_of_organization?(record.id)
  end

  # class Scope
  #   def resolve
  #     if user.admin_of_organization?(record.id)
  #       scope.all
  #     else
  #       scope.where(published: true)
  #     end
  #   end
  # end

  # def update?
  #   record.organization.admin_of_organization?(user)
  # end

  # def admin_list?
  #   invitation.admin?
  # end
end
