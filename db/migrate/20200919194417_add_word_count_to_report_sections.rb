class AddWordCountToReportSections < ActiveRecord::Migration[6.0]
  def change
    add_column :report_sections, :wordcount, :integer
  end
end
