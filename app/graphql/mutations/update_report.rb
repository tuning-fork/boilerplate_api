class Mutations::UpdateReport < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :grant_id, Integer, required: true
    argument :title, String, required: true
    argument :deadline, GraphQL::Types::DateTimeType, required: true
    argument :submitted, Boolean, required: true
    argument :archived, Boolean, required: true
  
    field :report, Types::ReportType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      report = Report.find(id)
      if report
        report.update!(attributes)
      end
      if report.save
        {
          report: report,
          errors: []
        }
      else
        {
          report: nil,
          errors: report.errors.full_messages
        }
      end
    end
end