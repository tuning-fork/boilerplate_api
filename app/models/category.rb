class Category < ApplicationRecord
  validates :name, length: { in: 1..50 }

  belongs_to :organization
end
