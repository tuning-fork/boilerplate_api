class RenameOrgIdInFundingOrgs < ActiveRecord::Migration[6.0]
  def change
    rename_column :funding_orgs, :org_id, :organization_id
  end
end
