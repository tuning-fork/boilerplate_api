# frozen_string_literal: true

class DefaultGrantBooleansToFalse < ActiveRecord::Migration[6.0]
  def change
    change_table :grants, bulk: true do |t|
      t.change_default :submitted, from: nil, to: false
      t.change_default :successful, from: nil, to: false
      t.change_default :archived, from: nil, to: false
    end

    # Cannot use t.change_null until we upgrade to rails 6.1
    change_column_null :grants, :submitted, false, false
    change_column_null :grants, :successful, false, false
    change_column_null :grants, :archived, false, false
  end
end
