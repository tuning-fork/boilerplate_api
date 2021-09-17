class Mutations::CreateBoilerplate < Mutations::BaseMutation
    argument :organization_id, Integer, required: true
    argument :category_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :boilerplate, Types::BoilerplateType, null: false
    field :errors, [String], null: false 
  
    def resolve(organization_id:, category_id:, title:, text:, wordcount:, archived:)
      boilerplate = Boilerplate.new(organization_id: organization_id, category_id: category_id, title: title, text: text, wordcount: wordcount, archived: archived)
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