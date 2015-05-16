class CreateStandardRanges < ActiveRecord::Migration
  def change
    create_table :standard_ranges do |t|
      t.integer :test_component_id
      t.string :gender
      t.string :comparision_type
      t.float :min
      t.float :max
      t.float :value
    end
  end
end
