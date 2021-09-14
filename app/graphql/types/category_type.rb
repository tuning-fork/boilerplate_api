module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :archived, Boolean, null: true
  end
end
