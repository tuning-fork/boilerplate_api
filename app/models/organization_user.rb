# frozen_string_literal: true

class OrganizationUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :roles, inclusion_list: Organization::Roles.all

  after_initialize do
    self.roles = [Organization::Roles::USER] if roles.blank?
  end
end
