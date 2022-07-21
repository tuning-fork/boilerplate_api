# frozen_string_literal: true

class AddArchivedToFundingOrgs < ActiveRecord::Migration[6.0]
  def change
    add_column :funding_orgs, :archived, :boolean, default: false
  end
end
