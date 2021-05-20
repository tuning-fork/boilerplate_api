class Section < ApplicationRecord
  belongs_to :grant

  include RankedModel
  ranks :sort_order
end
