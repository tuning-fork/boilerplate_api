class AddArchivedToGrants < ActiveRecord::Migration[6.0]
  def change
    add_column :grants, :archived, :boolean, default: false
  end
end
