class Bio < ApplicationRecord
  belongs_to :organization

  has_many :bio_grants
end
