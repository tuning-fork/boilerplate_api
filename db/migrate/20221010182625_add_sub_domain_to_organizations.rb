# frozen_string_literal: true

class AddSubDomainToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :subdomain, :string, default: '', null: false
    add_index :organizations, :subdomain, unique: true
  end
end
