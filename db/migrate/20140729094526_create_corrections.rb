class CreateCorrections < ActiveRecord::Migration
  def change
    create_table :corrections do |t|
      t.integer :prescription_id
      t.string :eye
      t.string :component
      t.string :condition
      t.string :value

      t.timestamps
    end
  end
end
