# frozen_string_literal: true

class RemoveBoilerplateIdFromSections < ActiveRecord::Migration[6.0]
  def change
    remove_column :sections, :boilerplate_id, :integer
  end
end
