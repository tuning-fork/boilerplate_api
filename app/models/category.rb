class Category < ApplicationRecord
  include TempUuidFallback
  before_save :set_foreign_key_uuids
  validates :name, length: { in: 1..50 }

  belongs_to :organization

  def set_foreign_key_uuids
    self.organization_uuid ||= self.organization.uuid
  end
end
