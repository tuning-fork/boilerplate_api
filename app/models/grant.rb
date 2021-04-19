class Grant < ApplicationRecord
  belongs_to :organization
  belongs_to :funding_org
  has_many :reports, dependent: :destroy
  has_many :sections, dependent: :destroy

  has_many :bio_grants
end
