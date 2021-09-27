class Mutations::DestroyReport < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :report, Types::ReportType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        report = Report.find(id)
        report.destroy
    end
end