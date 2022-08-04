# frozen_string_literal: true

class AddArchivedToBios < ActiveRecord::Migration[6.0]
  def change
    add_column :bios, :archived, :boolean, default: false
  end
end
