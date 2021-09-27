class Mutations::DestroyBoilerplate < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :boilerplate, Types::BoilerplateType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        boilerplate = Boilerplate.find(id)
        boilerplate.destroy
    end
end
