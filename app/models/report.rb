class Report < ApplicationRecord
  belongs_to :grant, :dependent_destroy

  has_many :report_sections

end
