class Boilerplate < ApplicationRecord
  include TempUuidFallback
  before_save :set_foreign_key_uuids
  validates :title, length: { in: 2..255 }

  belongs_to :organization
  belongs_to :category
  has_many :sections

  def set_foreign_key_uuids
    self.organization_uuid ||= self.organization.uuid
    self.category_uuid ||= self.category.uuid
  end
end
