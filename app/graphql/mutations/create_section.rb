class Mutations::CreateSection < Mutations::BaseMutation
    argument :grant_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :sort_order, Integer, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :section, Types::SectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(grant_id:, title:, text:, sort_order:, wordcount:, archived:)
      section = Section.new(grant_id: grant_id, title: title, text: text, sort_order: sort_order, wordcount: wordcount, archived: archived,)
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