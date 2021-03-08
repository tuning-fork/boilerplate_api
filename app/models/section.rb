class Section < ApplicationRecord
  belongs_to :grant, dependent: :destroy
end
