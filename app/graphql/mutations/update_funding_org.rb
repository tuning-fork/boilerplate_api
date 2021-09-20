class Mutations::UpdateFundingOrg < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :website, String, required: true
    argument :name, String, required: true
    argument :organization_id, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :funding_org, Types::FundingOrgType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      funding_org = FundingOrg.find(id)
        if funding_org
        funding_org.update!(attributes)
        if funding_org.save
        {
          funding_org: funding_org,
          errors: []
        }
      else
        {
          funding_org: nil,
          errors: funding_org.errors.full_messages
        }
      end
    end
end