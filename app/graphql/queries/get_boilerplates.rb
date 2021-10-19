module Queries
    class GetBoilerplates < Queries::BaseQuery
      type [Types::BoilerplateType], null: false
  
      def resolve
        Boilerplate.all
      end
    end
end

