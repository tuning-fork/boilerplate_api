class User < ApplicationRecord
  has_many :organization_users
  has_secure_password
  validates :email, presence: true, uniqueness: true

end
