# frozen_string_literal: true

class ReportSection < ApplicationRecord
  validates :title, length: { in: 2..255 }

  belongs_to :report
end
