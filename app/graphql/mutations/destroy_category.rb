class Mutations::DestroyCategory < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :category, Types::CategoryType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        category = Category.find(id)
        category.destroy
    end
end
