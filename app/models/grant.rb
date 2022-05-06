class Grant < ApplicationRecord
  include TempUuidFallback

  before_save :set_foreign_key_uuids

  validates :title, length: { in: 2..100 }

  belongs_to :organization
  belongs_to :funding_org
  has_many :reports, dependent: :destroy
  has_many :sections, dependent: :destroy

  private

  def set_foreign_key_uuids
    self.organization_uuid ||= self.organization.uuid
    self.funding_org_uuid ||= self.funding_org.uuid
  end
end
