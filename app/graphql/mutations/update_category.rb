class Mutations::UpdateCategory < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :name, String, required: true
  
    field :category, Types::CategoryType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      category = Category.find(id)
        if category
        category.update!(attributes)
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