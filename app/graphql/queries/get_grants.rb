module Queries
    class GetGrants < Queries::BaseQuery
      type [Types::GrantType], null: false
  
      def resolve
        Grant.all
      end
    end
end