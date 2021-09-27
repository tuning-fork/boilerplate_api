class Mutations::UpdateGrant < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :organization_id, Integer, required: true
    argument :title, String, required: true
    argument :funding_org_id, Integer, required: true
    argument :rfp_url, String, required: true
    argument :deadline, Date, required: true
    argument :submitted, Boolean, required: true
    argument :successful, Boolean, required: true
    argument :purpose, Strong, required: true
    argument :archived, Boolean, required: true
  
    field :grant, Types::GrantType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      grant = Grant.find(id)
      if grant
        grant.update!(attributes)
      end
      if grant.save
        {
          grant: grant,
          errors: []
        }
      else
        {
          grant: nil,
          errors: grant.errors.full_messages
        }
      end
    end
end