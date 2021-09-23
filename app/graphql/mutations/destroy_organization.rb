class Mutations::DestroyOrganization < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :organization, Types::OrganizationType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        organization = Organization.find(organization_id)
        organization.destroy
    end
end