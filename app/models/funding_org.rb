class FundingOrg < ApplicationRecord
  include TempUuidFallback
  validates :name, length: { in: 2..255 }

  belongs_to :organization
end
