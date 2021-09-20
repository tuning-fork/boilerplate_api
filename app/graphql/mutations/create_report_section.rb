class Mutations::CreateReportSection < Mutations::BaseMutation
    argument :report_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :sort_order, Integer, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :report_section, Types::ReportSectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(report_id:, title:, text:, sort_order:, wordcount:, archived:)
      report_section = ReportSection.new(report_id: grant_id, title: title, text: text, sort_order: sort_order, wordcount: wordcount, archived: archived,)
          if report_section.save
        {
          report_section: report_section,
          errors: []
        }
      else
        {
          report_section: nil,
          errors: report_section.errors.full_messages
        }
      end
    end
end