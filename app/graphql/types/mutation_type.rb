module Types
  class MutationType < Types::BaseObject
    field :create_organization, mutation: Mutations::Organizations::CreateOrganization
    field :destroy_organization, mutation: Mutations::Organizations::DestroyOrganization
    field :update_organization, mutation: Mutations::Organizations::UpdateOrganization
    field :create_boilerplate, mutation: Mutations::Boilerplates::CreateBoilerplate
    field :destroy_boilerplate, mutation: Mutations::Boilerplates::DestroyBoilerplate
    field :update_boilerplate, mutation: Mutations::Boilerplates::UpdateBoilerplate
    field :create_category, mutation: Mutations::Categories::CreateCategory
    field :destroy_category, mutation: Mutations::Categories::DestroyCategory
    field :update_category, mutation: Mutations::Categories::UpdateCategory
    field :create_funding_org, mutation: Mutations::FundingOrgs::CreateFundingOrg
    field :destroy_funding_org, mutation: Mutations::FundingOrgs::DestroyFundingOrg
    field :update_funding_org, mutation: Mutations::FundingOrgs::UpdateFundingOrg
    field :create_grant, mutation: Mutations::Grants::CreateGrant
    field :destroy_grant, mutation: Mutations::Grants::DestroyGrant
    field :update_grant, mutation: Mutations::Grants::UpdateGrant
    field :create_report, mutation: Mutations::Reports::CreateReport
    field :destroy_report, mutation: Mutations::Reports::DestroyReport
    field :update_report, mutation: Mutations::Reports::UpdateReport
    field :create_report_section, mutation: Mutations::ReportSections::CreateReportSection
    field :destroy_report_section, mutation: Mutations::ReportSections::DestroyReportSection
    field :update_report_section, mutation: Mutations::ReportSections::UpdateReportSection
    field :create_section, mutation: Mutations::Sections::CreateSection
    field :destroy_section, mutation: Mutations::Sections::DestroySection
    field :update_section, mutation: Mutations::Sections::UpdateSection
    field :create_user, mutation: Mutations::Users::CreateUser
    field :destroy_user, mutation: Mutations::Users::DestroyUser
    field :update_user, mutation: Mutations::Users::UpdateUser
  end
end
