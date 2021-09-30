module Queries
    class GetCategories < Queries::BaseQuery
      type [Types::CategoryType], null: false
  
      def resolve
        Category.all
      end
    end
end