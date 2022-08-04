# frozen_string_literal: true

class AddUuidForeignKeys < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      UPDATE organization_users
      SET organization_uuid = organizations.uuid
      FROM organizations
      WHERE organizations.id = organization_users.organization_id;
    SQL

    execute <<-SQL
      UPDATE organization_users
      SET user_uuid = users.uuid
      FROM users
      WHERE users.id = organization_users.user_id;
    SQL

    execute <<-SQL
      UPDATE boilerplates
      SET organization_uuid = organizations.uuid
      FROM organizations
      WHERE organizations.id = boilerplates.organization_id;
    SQL

    execute <<-SQL
      UPDATE boilerplates
      SET category_uuid = categories.uuid
      FROM categories
      WHERE categories.id = boilerplates.category_id;
    SQL

    execute <<-SQL
      UPDATE categories
      SET organization_uuid = organizations.uuid
      FROM organizations
      WHERE organizations.id = categories.organization_id;
    SQL

    execute <<-SQL
      UPDATE funding_orgs
      SET organization_uuid = organizations.uuid
      FROM organizations
      WHERE organizations.id = funding_orgs.organization_id;
    SQL

    execute <<-SQL
      UPDATE grants
      SET organization_uuid = organizations.uuid
      FROM organizations
      WHERE organizations.id = grants.organization_id;
    SQL

    execute <<-SQL
      UPDATE grants
      SET funding_org_uuid = funding_orgs.uuid
      FROM funding_orgs
      WHERE funding_orgs.id = grants.funding_org_id;
    SQL

    execute <<-SQL
      UPDATE sections
      SET grant_uuid = grants.uuid
      FROM grants
      WHERE grants.id = sections.grant_id;
    SQL

    execute <<-SQL
      UPDATE reports
      SET grant_uuid = grants.uuid
      FROM grants
      WHERE grants.id = reports.grant_id;
    SQL

    execute <<-SQL
      UPDATE report_sections
      SET report_uuid = reports.uuid
      FROM reports
      WHERE reports.id = report_sections.report_id;
    SQL
  end

  def down
    execute <<-SQL
      UPDATE organization_users SET organization_uuid = null, user_uuid = null
    SQL

    execute <<-SQL
      UPDATE boilerplates SET organization_uuid = null, category_uuid = null
    SQL

    execute <<-SQL
      UPDATE categories SET organization_uuid = null
    SQL

    execute <<-SQL
      UPDATE funding_orgs SET organization_uuid = null
    SQL

    execute <<-SQL
      UPDATE grants SET organization_uuid = null, funding_org_uuid = null
    SQL

    execute <<-SQL
      UPDATE sections SET grant_uuid = null
    SQL

    execute <<-SQL
      UPDATE reports SET grant_uuid = null
    SQL

    execute <<-SQL
      UPDATE report_sections SET report_uuid = null
    SQL
  end
end
