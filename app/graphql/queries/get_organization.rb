module Queries
    class GetOrganization < Queries::BaseQuery
        type [Types::OrganizationType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        Organization.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('Organization does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end