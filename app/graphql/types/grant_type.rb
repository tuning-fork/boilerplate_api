module Types
  class GrantType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :title, String, null: true
    field :funding_org_id, Integer, null: true
    field :rfp_url, String, null: true
    field :deadline, GraphQL::Types::ISO8601DateTime, null: true
    field :submitted, Boolean, null: true
    field :successful, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :purpose, String, null: true
    field :archived, Boolean, null: true
    field :section, [Types::SectionType], null: true
    field :reports, [Types::ReportType], null: true
  end
end
