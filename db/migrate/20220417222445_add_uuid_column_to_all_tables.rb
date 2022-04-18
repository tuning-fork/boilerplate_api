class AddUuidColumnToAllTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    add_column :organizations, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :organization_users, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :grants, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :sections, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :reports, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :report_sections, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :boilerplates, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :funding_orgs, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :categories, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :organization_users, :organization_uuid, :uuid
    add_column :organization_users, :user_uuid, :uuid
    add_column :boilerplates, :organization_uuid, :uuid
    add_column :boilerplates, :category_uuid, :uuid
    add_column :categories, :organization_uuid, :uuid
    add_column :funding_orgs, :organization_uuid, :uuid
    add_column :grants, :organization_uuid, :uuid
    add_column :grants, :funding_org_uuid, :uuid
    add_column :sections, :grant_uuid, :uuid
    add_column :reports, :grant_uuid, :uuid
    add_column :report_sections, :report_uuid, :uuid
  end
end
