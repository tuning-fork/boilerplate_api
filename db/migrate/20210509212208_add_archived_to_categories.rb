# frozen_string_literal: true

class AddArchivedToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :archived, :boolean, default: false
  end
end
