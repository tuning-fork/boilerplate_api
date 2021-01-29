class ReportSection < ApplicationRecord
  belongs_to :report, :dependent_destroy
end
