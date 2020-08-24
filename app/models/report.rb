class Report < ApplicationRecord
  belongs_to :grant

  has_many :report_sections

end
