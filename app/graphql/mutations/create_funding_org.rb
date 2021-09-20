class Mutations::CreateFundingOrg < Mutations::BaseMutation
    argument :website, String, required: true
    argument :name, String, required: true
    argument :organization_id, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :funding_org, Types::FundingOrgType, null: false
    field :errors, [String], null: false 
  
    def resolve(website:, name:, organization_id:, archived:)
      funding_org = FundingOrg.new(website: website, name: name, organiation_id: organization_id, archived: archived)
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