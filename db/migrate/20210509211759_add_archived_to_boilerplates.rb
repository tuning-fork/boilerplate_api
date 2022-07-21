# frozen_string_literal: true

class AddArchivedToBoilerplates < ActiveRecord::Migration[6.0]
  def change
    add_column :boilerplates, :archived, :boolean, default: false
  end
end
