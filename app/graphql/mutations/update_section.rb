class Mutations::UpdateSection < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :grant_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :sort_order, Integer, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :section, Types::SectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      section = Section.find(id)
      if section
        section.update!(attributes)
      end
      if section.save
        {
          section: section,
          errors: []
        }
      else
        {
          section: nil,
          errors: section.errors.full_messages
        }
      end
    end
end