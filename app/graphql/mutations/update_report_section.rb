class Mutations::UpdateReportSection < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :report_id, Integer, required: true
    argument :title, String, required: true
    argument :text, String, required: true
    argument :sort_order, Integer, required: true
    argument :wordcount, Integer, required: true
    argument :archived, Boolean, required: true
  
    field :report_section, Types::ReportSectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      report_section = ReportSection.find(id)
      if report_section
        report_section.update!(attributes)
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