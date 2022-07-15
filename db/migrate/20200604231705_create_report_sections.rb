# frozen_string_literal: true

class CreateReportSections < ActiveRecord::Migration[6.0]
  def change
    create_table :report_sections do |t|
      t.integer :report_id
      t.string :title
      t.text :text
      t.integer :sort_order

      t.timestamps
    end
  end
end
