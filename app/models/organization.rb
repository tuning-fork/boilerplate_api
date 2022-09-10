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
  has_many :organization_users, dependent: :destroy
  has_many :users, -> { order(last_name: :asc, first_name: :asc) }, through: :organization_users

  def to_s
    "#<Organization:#{id}>"
  end
end
