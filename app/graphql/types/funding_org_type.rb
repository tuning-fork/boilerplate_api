module Types
  class FundingOrgType < Types::BaseObject
    field :id, ID, null: false
    field :website, String, null: true
    field :name, String, null: true
    field :organization_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :archived, Boolean, null: true
  end
end