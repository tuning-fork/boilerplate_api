class ReportSection < ApplicationRecord
  include TempUuidFallback
  before_save :set_foreign_key_uuids

  validates :title, length: { in: 2..255 }

  belongs_to :report

  def set_foreign_key_uuids
    self.report_uuid ||= self.report.uuid
  end
end
