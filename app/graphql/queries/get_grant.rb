module Queries
    class GetGrant < Queries::BaseQuery
        type [Types::GrantType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        Grant.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Grant does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end