module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # /organizations
    field :organizations, [Types::OrganizationType], null: false

    def organizations
      Organization.all
    end

    # /organization/:id
    field :organization, Types::OrganizationType, null: false do
      argument :id, ID, required: true
    end

    def organization(id:)
      Organization.find(id)
    end

    # /boilerplates
    field :boilerplates, [Types::BoilerplateType], null: false

    def boilerplates
      Boilerplate.all
    end

    # /boilerplate/:id
    field :boilerplate, Types::BoilerplateType, null: false do
      argument :id, ID, required: true
    end

    def boilerplate(id:)
      Boilerplate.find(id)
    end

    # /categories
    field :categories, [Types::CategoryType], null: false

    def categories
      Category.all
    end

    # /category/:id
    field :user, Types::CategoryType, null: false do
      argument :id, ID, required: true
    end

    def category(id:)
      Category.find(id)
    end

    # /funding_orgs
    field :funding_orgs, [Types::FundingOrgType], null: false

    def funding_orgs
      FundingOrg.all
    end

    # /funding_org/:id
    field :funding_org, Types::FundingOrgType, null: false do
      argument :id, ID, required: true
    end

    def funding_org(id:)
      FundingOrg.find(id)
    end

    # /grants
    field :grants, [Types::GrantType], null: false

    def grants
      Grant.all
    end

    # /grant/:id
    field :grant, Types::GrantType, null: false do
      argument :id, ID, required: true
    end

    def grant(id:)
      Grant.find(id)
    end

    # /reports
    field :reports, [Types::ReportType], null: false

    def reports
      Report.all
    end

    # /report/:id
    field :report, Types::ReportType, null: false do
      argument :id, ID, required: true
    end

    def report(id:)
      Report.find(id)
    end

    # /sections
    field :sections, [Types::SectionType], null: false

    def sections
      Section.all
    end

    # /section/:id
    field :section, Types::SectionType, null: false do
      argument :id, ID, required: true
    end

    def section(id:)
      Section.find(id)
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
