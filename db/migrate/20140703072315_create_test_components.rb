class CreateTestComponents < ActiveRecord::Migration
  def change
    create_table :test_components do |t|
      t.string :name
      t.string :standard_range
      t.string :units
      t.integer :lab_test_id

      t.timestamps
    end
  end
end
