module Types
  class SectionType < Types::BaseObject
    field :id, ID, null: false
    field :grant_id, ID, null: true
    field :title, String, null: true
    field :text, String, null: true
    field :sort_order, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :wordcount, Integer, null: true
    field :archived, Boolean, null: true
  end
end
