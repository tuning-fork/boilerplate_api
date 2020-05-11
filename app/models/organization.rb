class Organization < ApplicationRecord
  has_many :boilerplates
  has_many :bios 
  has_many :grants
  has_many :categories
  has_many :funding_orgs

  has_many :organization_users
end
