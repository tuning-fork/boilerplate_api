module Queries
    class GetReports < Queries::BaseQuery
      type [Types::ReportType], null: false
  
      def resolve
        Report.all
      end
    end
end