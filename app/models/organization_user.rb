class OrganizationUser < ApplicationRecord
  include TempUuidFallback

  after_save :set_foreign_key_uuids

  belongs_to :organization
  belongs_to :user

  private

  def set_foreign_key_uuids
    self.organization_uuid ||= self.organization.uuid
    self.user_uuid ||= self.user.uuid
  end
end
