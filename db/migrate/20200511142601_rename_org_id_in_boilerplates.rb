class RenameOrgIdInBoilerplates < ActiveRecord::Migration[6.0]
  def change
    rename_column :boilerplates, :org_id, :organization_id
  end
end
