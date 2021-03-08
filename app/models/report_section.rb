class ReportSection < ApplicationRecord
  belongs_to :report, dependent: :destroy
end
