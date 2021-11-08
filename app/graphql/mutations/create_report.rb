class Mutations::CreateReport < Mutations::BaseMutation
    argument :grant_id, Integer, required: true
    argument :title, String, required: true
    # argument :deadline, GraphQL::Types::DateTimeType, required: true
    argument :deadline, GraphQL::Types::ISO8601DateTime, required: true
    argument :submitted, Boolean, required: true
    argument :archived, Boolean, required: true

    field :grant, Types::ReportType, null: false
    field :errors, [String], null: false 
  
    def resolve(grant_id:,
        title:,
        deadline:,
        submitted:,
        archived:)
      grant = Report.new(grant_id: grant_id,
        title: title,
        deadline: deadline,
        submitted: submitted,
        archived: archived)
          if grant.save
        {
          grant: grant,
          errors: []
        }
      else
        {
          grant: nil,
          errors: grant.errors.full_messages
        }
      end
    end
end