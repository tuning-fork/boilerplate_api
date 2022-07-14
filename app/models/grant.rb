class Grant < ApplicationRecord
  validates :title, length: { in: 2..100 }

  belongs_to :organization
  belongs_to :funding_org
  has_many :reports, dependent: :destroy
  has_many :sections, dependent: :destroy
end
