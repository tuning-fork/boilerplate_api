class Mutations::CreateCategory < Mutations::BaseMutation
    argument :organization_id, Integer, required: true
    argument :name, String, required: true
    argument :archived, Boolean, required: true
  
    field :category, Types::CategoryType, null: false
    field :errors, [String], null: false 
  
    def resolve(organization_id:, name:, archived:)
      category = Category.new(organization_id: organization_id, name: name, archived: archived)
      if category.save
        {
        category: category,
        errors: []
        }
      else
      {
        category: nil,
        errors: category.errors.full_messages
      }
      end
    end
end