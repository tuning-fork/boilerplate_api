module Queries
    class GetBoilerplate < Queries::BaseQuery
        type [Types::BoilerplateType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        Boilerplate.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Boilerplate does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end