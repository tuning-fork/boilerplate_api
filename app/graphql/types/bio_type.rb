module Types
  class BioType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :text, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :title, String, null: true
    field :wordcount, Integer, null: true
    field :archived, Boolean, null: true
  end
end
