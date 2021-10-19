module Queries
    class GetReportSection < Queries::BaseQuery
        type [Types::ReportSectionType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        ReportSection.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Report Section does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end