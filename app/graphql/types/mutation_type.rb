module Types
  class MutationType < BaseObject
    field :create_organization, mutation: Mutations::CreateOrganization
    field :destroy_organization, mutation: Mutations::DestroyOrganization
    field :update_organization, mutation: Mutations::UpdateOrganization
    field :create_boilerplate, mutation: Mutations::CreateBoilerplate
    field :destroy_boilerplate, mutation: Mutations::DestroyBoilerplate
    field :update_boilerplate, mutation: Mutations::UpdateBoilerplate
    field :create_category, mutation: Mutations::CreateCategory
    field :destroy_category, mutation: Mutations::DestroyCategory
    field :update_category, mutation: Mutations::UpdateCategory
    field :create_funding_org, mutation: Mutations::CreateFundingOrg
    field :destroy_funding_org, mutation: Mutations::DestroyFundingOrg
    field :update_funding_org, mutation: Mutations::UpdateFundingOrg
    field :create_grant, mutation: Mutations::CreateGrant
    field :destroy_grant, mutation: Mutations::DestroyGrant
    field :update_grant, mutation: Mutations::UpdateGrant
    field :create_report, mutation: Mutations::CreateReport
    field :destroy_report, mutation: Mutations::DestroyReport
    field :update_report, mutation: Mutations::UpdateReport
    field :create_report_section, mutation: Mutations::CreateReportSection
    field :destroy_report_section, mutation: Mutations::DestroyReportSection
    field :update_report_section, mutation: Mutations::UpdateReportSection
    field :create_section, mutation: Mutations::CreateSection
    field :destroy_section, mutation: Mutations::DestroySection
    field :update_section, mutation: Mutations::UpdateSection
    field :create_user, mutation: Mutations::CreateUser
    field :destroy_user, mutation: Mutations::DestroyUser
    field :update_user, mutation: Mutations::UpdateUser
  end
end