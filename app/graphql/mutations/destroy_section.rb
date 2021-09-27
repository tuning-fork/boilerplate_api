class Mutations::DestroySection < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :section, Types::SectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        section = Section.find(id)
        section.destroy
    end
end
