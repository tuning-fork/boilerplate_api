class Report < ApplicationRecord
  include TempUuidFallback

  before_save :set_foreign_key_uuids
  validates :title, length: { in: 2..100 }

  belongs_to :grant

  has_many :report_sections
  
  private

  def set_foreign_key_uuids
    self.grant_uuid ||= self.grant.uuid
  end
end
