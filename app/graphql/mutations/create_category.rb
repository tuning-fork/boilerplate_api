class Mutations::CreateCategory < Mutations::BaseMutation
    argument :organization_id, Integer, required: true
    argument :name, String, required: true
    argument :archived, Boolean, required: true
  
    field :category, Types::CategoryType, null: false
    field :errors, [String], null: false 
  
    def resolve(organization_id:, name:, archived:,)
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