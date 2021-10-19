module Queries
    class GetCategory < Queries::BaseQuery
        type [Types::CategoryType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        Category.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Category does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end