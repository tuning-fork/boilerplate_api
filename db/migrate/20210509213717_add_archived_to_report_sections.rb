class AddArchivedToReportSections < ActiveRecord::Migration[6.0]
  def change
    add_column :report_sections, :archived, :boolean, default: false
  end
end
