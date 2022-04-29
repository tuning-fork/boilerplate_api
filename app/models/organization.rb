class Organization < ApplicationRecord
  validates :name, length: { in: 2..60 }

  has_many :boilerplates
  has_many :grants
  has_many :categories
  has_many :funding_orgs
  has_many :organization_users
  has_many :users, through: :organization_users

  def to_s
    "#<Organization:#{self.id}>"
  end

  @_uuid = nil
  def uuid
    ret = @_uuid || attributes["uuid"] || Organization.find(self.id).uuid
    @_uuid = ret
    ret
  end
end
