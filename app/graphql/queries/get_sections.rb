module Queries
    class GetSections < Queries::BaseQuery
      type [Types::SectionType], null: false
  
      def resolve
        Section.all
      end
    end
end