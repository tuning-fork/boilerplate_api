# frozen_string_literal: true

class AddPurposeToGrants < ActiveRecord::Migration[6.0]
  def change
    add_column :grants, :purpose, :string
  end
end
