module Types
  class BoilerplateType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, ID, null: true
    field :category_id, ID, null: true
    field :title, String, null: true
    field :text, String, null: true
    field :wordcount, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :archived, Boolean, null: true
  end
end
