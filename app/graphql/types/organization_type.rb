module Types
  class OrganizationType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :boilerplates, [Types::BoilerplateType], null: true
    field :categories, [Types::CategoryType], null: true
    field :funding_orgs, [Types::FundingOrgType], null: true
    field :grants, [Types::GrantType], null: true
  end
end
