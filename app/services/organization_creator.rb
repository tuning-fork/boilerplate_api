# frozen_string_literal: true

class OrganizationCreator
  def call!(organization_params, creator)
    organization = Organization.create!(
      **organization_params,
      users: [creator]
    )

    organization.add_user_role(creator, Organization::Roles::ADMIN)

    Rails.logger.info("New organization #{organization} created by #{creator}")

    organization
  end
end
