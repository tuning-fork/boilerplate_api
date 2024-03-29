# frozen_string_literal: true

class Boilerplate < ApplicationRecord
  validates :title, length: { in: 2..255 }

  belongs_to :organization
  belongs_to :category
end
