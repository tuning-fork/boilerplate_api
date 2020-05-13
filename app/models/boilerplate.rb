class Boilerplate < ApplicationRecord
  belongs_to :organization
  has_many :sections

  belongs_to :category

  
end
