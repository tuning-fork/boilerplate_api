class User < ApplicationRecord
  has_many :organization_users
end
