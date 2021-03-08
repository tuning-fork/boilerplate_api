class Report < ApplicationRecord
  belongs_to :grant, dependent: :destroy

  has_many :report_sections

end
