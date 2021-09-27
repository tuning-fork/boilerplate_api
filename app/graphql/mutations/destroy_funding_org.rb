class Mutations::DestroyFundingOrg < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :funding_org, Types::FundingOrgType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        funding_org = FundingOrg.find(id)
        funding_org.destroy
    end
end
