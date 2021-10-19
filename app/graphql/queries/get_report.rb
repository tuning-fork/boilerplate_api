module Queries
    class GetReport < Queries::BaseQuery
        type [Types::ReportType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        Report.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Report does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end