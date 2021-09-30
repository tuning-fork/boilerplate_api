module Queries
    class GetFundingOrgs < Queries::BaseQuery
      type [Types::FundingOrgType], null: false
  
      def resolve
        FundingOrg.all
      end
    end
end