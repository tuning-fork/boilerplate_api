class Section < ApplicationRecord
  include RankedModel
  include TempUuidFallback

  before_save :set_foreign_key_uuids

  validates :title, length: { in: 2..255 }

  belongs_to :grant

  ranks :sort_order

  private

  def set_foreign_key_uuids
    self.grant_uuid ||= self.grant.uuid
  end
end
