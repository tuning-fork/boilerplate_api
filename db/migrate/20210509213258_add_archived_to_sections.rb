class AddArchivedToSections < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :archived, :boolean, default: false
  end
end
