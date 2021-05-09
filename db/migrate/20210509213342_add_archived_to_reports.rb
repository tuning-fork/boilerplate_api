class AddArchivedToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :archived, :boolean, default: false
  end
end
