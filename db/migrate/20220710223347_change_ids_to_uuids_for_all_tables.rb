class ChangeIdsToUuidsForAllTables < ActiveRecord::Migration[6.0]
  def change
    remove_column :organizations, :id
    remove_column :organization_users, :id
    remove_column :grants, :id
    remove_column :sections, :id
    remove_column :reports, :id
    remove_column :report_sections, :id
    remove_column :boilerplates, :id
    remove_column :funding_orgs, :id
    remove_column :categories, :id
    remove_column :users, :id
    remove_column :organization_users, :organization_id
    remove_column :organization_users, :user_id
    remove_column :boilerplates, :organization_id
    remove_column :boilerplates, :category_id
    remove_column :categories, :organization_id
    remove_column :funding_orgs, :organization_id
    remove_column :grants, :organization_id
    remove_column :grants, :funding_org_id
    remove_column :sections, :grant_id
    remove_column :reports, :grant_id
    remove_column :report_sections, :report_id
    
    rename_column :organizations, :uuid, :id
    rename_column :organization_users, :uuid, :id
    rename_column :grants, :uuid, :id
    rename_column :sections, :uuid, :id
    rename_column :reports, :uuid, :id
    rename_column :report_sections, :uuid, :id
    rename_column :boilerplates, :uuid, :id
    rename_column :funding_orgs, :uuid, :id
    rename_column :categories, :uuid, :id
    rename_column :users, :uuid, :id
    rename_column :organization_users, :organization_uuid, :organization_id
    rename_column :organization_users, :user_uuid, :user_id
    rename_column :boilerplates, :organization_uuid, :organization_id
    rename_column :boilerplates, :category_uuid, :category_id
    rename_column :categories, :organization_uuid, :organization_id
    rename_column :funding_orgs, :organization_uuid, :organization_id
    rename_column :grants, :organization_uuid, :organization_id
    rename_column :grants, :funding_org_uuid, :funding_org_id
    rename_column :sections, :grant_uuid, :grant_id
    rename_column :reports, :grant_uuid, :grant_id
    rename_column :report_sections, :report_uuid, :report_id

    # add_index :organization_users, [:organization_id, :user_id], unique: true
  end
end
