class Section < ApplicationRecord
  validates :title, length: { in: 2..255 }

  belongs_to :grant

  include RankedModel
  ranks :sort_order
end
