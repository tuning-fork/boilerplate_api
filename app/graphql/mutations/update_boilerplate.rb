class Mutations::UpdateBoilerplate < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :organization_id, Integer, required: true
    argument :category_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :boilerplate, Types::BoilerplateType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      boilerplate = Boilerplate.find(id)
        if boilerplate
        boilerplate.update!(attributes)
        if boilerplate.save
        {
          boilerplate: boilerplate,
          errors: []
        }
      else
        {
          boilerplate: nil,
          errors: boilerplate.errors.full_messages
        }
      end
    end
end