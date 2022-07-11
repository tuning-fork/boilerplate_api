class FundingOrg < ApplicationRecord
  validates :name, length: { in: 2..255 }
  belongs_to :organization
end
