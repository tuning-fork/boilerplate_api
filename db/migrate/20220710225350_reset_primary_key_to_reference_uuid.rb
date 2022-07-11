class ResetPrimaryKeyToReferenceUuid < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE organizations ADD PRIMARY KEY (id);"
    execute "ALTER TABLE organization_users ADD PRIMARY KEY (id);"
    execute "ALTER TABLE grants ADD PRIMARY KEY (id);"
    execute "ALTER TABLE sections ADD PRIMARY KEY (id);"
    execute "ALTER TABLE reports ADD PRIMARY KEY (id);"
    execute "ALTER TABLE report_sections ADD PRIMARY KEY (id);"
    execute "ALTER TABLE boilerplates ADD PRIMARY KEY (id);"
    execute "ALTER TABLE funding_orgs ADD PRIMARY KEY (id);"
    execute "ALTER TABLE categories ADD PRIMARY KEY (id);"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end

  def down
    execute "ALTER TABLE organizations DROP CONSTRAINT organizations_pkey;"
    execute "ALTER TABLE organization_users DROP CONSTRAINT organization_users_pkey;"
    execute "ALTER TABLE grants DROP CONSTRAINT grants_pkey;"
    execute "ALTER TABLE sections DROP CONSTRAINT sections_pkey;"
    execute "ALTER TABLE reports DROP CONSTRAINT reports_pkey;"
    execute "ALTER TABLE report_sections DROP CONSTRAINT report_sections_pkey;"
    execute "ALTER TABLE boilerplates DROP CONSTRAINT boilerplates_pkey;"
    execute "ALTER TABLE funding_orgs DROP CONSTRAINT funding_orgs_pkey;"
    execute "ALTER TABLE categories DROP CONSTRAINT categories_pkey;"
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey;"
  end
end
