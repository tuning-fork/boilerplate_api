class Grant < ApplicationRecord
  belongs_to :organization
  belongs_to :funding_org
  has_many :reports
  has_many :sections
  
  has_many :bio_grants

end

