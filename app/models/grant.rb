class Grant < ApplicationRecord
  before_save :set_organization_uuid
    
  validates :title, length: { in: 2..100 }

  belongs_to :organization
  belongs_to :funding_org
  has_many :reports, dependent: :destroy
  has_many :sections, dependent: :destroy

  private

  def set_organization_uuid
    self.organization_uuid = self.organization.uuid if self.organization_uuid === nil
  end
end
