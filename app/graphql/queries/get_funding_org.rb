module Queries
    class GetFundingOrg < Queries::BaseQuery
        type [Types::FundingOrgType], null: false
        argument :id, ID, required: true
  
      def resolve(id:)
        FundingOrg.find(id)
        rescue ActiveRecord::RecordNotFound => _e
            GraphQL::ExecutionError.new('FundingOrg does not exist.')
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
            " #{e.record.errors.full_messages.join(', ')}")
      end
    end
end