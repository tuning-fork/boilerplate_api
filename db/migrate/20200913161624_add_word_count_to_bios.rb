class AddWordCountToBios < ActiveRecord::Migration[6.0]
  def change

    add_column :bios, :wordcount, :integer
  end
end
