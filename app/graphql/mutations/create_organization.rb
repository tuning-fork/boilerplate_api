class Mutations::CreateOrganization < Mutations::BaseMutation
    argument :name, String, required: true
  
    field :organization, Types::OrganizationType, null: false
    field :errors, [String], null: false 
  
    def resolve(name:)
      organization = Organization.new(name: name)
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