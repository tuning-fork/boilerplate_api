module Types
  class ReportType < Types::BaseObject
    field :id, ID, null: false
    field :grant_id, Integer, null: true
    field :title, String, null: true
    field :deadline, GraphQL::Types::ISO8601DateTime, null: true
    field :submitted, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :archived, Boolean, null: true
    field :report_sections, [Types::ReportSectionType], null: true
  end
end
