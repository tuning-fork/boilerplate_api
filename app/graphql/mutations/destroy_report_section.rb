class Mutations::DestroyReportSection < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :report_section, Types::ReportSectionType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        report_section = ReportSection.find(id)
        report_section.destroy
    end
end
