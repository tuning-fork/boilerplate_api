module Queries
    class GetReportSections < Queries::BaseQuery
      type [Types::ReportSectionType], null: false
  
      def resolve
        ReportSection.all
      end
    end
end