# frozen_string_literal: true

class Report < ApplicationRecord
  validates :title, length: { in: 2..100 }

  belongs_to :grant

  has_many :report_sections
end
