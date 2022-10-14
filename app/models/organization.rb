# frozen_string_literal: true

class Organization < ApplicationRecord
  module Roles
    USER = 'user'
    ADMIN = 'admin'

    def self.all
      [USER, ADMIN]
    end
  end

  validates :name, length: { in: 2..60 }

  has_many :boilerplates, dependent: :destroy
  has_many :grants, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :funding_orgs, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :pending_invitations, lambda {
                                   where(user_id: nil)
                                 }, class_name: 'Invitation', dependent: :destroy, inverse_of: :organization
  has_many :users, lambda {
                     order(last_name: :asc, first_name: :asc)
                   }, dependent: :destroy, inverse_of: :organization
  has_many :admins, lambda {
                      where('? = ANY(roles)', Roles::ADMIN).order(last_name: :asc, first_name: :asc)
                    }, dependent: :destroy, class_name: 'User', inverse_of: :organization

  def to_s
    "#<Organization:#{id}>"
  end

  def add_user_role(user, role)
    organization_user = OrganizationUser.find_by!(organization_id: id, user_id: user.id)
    organization_user.update!(roles: [role])
  end
end
