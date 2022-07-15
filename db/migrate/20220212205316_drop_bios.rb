# frozen_string_literal: true

class DropBios < ActiveRecord::Migration[6.0]
  def change
    drop_table :bios
  end
end
