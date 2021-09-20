class Mutations::UpdateOrganization < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :name, String, required: true
  
    field :organization, Types::OrganizationType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      organization = Organization.find(id)
        if organization
        organization.update!(attributes)
        if organization.save
        {
          organization: organization,
          errors: []
        }
      else
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
end