class FundingOrg < ApplicationRecord
  include TempUuidFallback

  before_save :set_foreign_key_uuids

  validates :name, length: { in: 2..255 }
  belongs_to :organization

  private

  def set_foreign_key_uuids
    self.organization_uuid ||= self.organization.uuid
  end
end
