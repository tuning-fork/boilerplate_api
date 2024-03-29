# frozen_string_literal: true

class Section < ApplicationRecord
  include RankedModel

  validates :title, length: { in: 2..255 }

  belongs_to :grant

  ranks :sort_order,
        with_same: :grant_id
end
