class AddTitleToBios < ActiveRecord::Migration[6.0]
  def change
    add_column :bios, :title, :string
  end
end
