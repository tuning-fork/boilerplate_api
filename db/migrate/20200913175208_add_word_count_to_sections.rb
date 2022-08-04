# frozen_string_literal: true

class AddWordCountToSections < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :wordcount, :integer
  end
end
