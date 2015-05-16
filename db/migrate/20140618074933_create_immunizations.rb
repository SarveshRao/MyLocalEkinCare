class CreateImmunizations < ActiveRecord::Migration
  def change
    create_table :immunizations do |t|
      t.date :date
      t.string :name
      t.string :type
      t.float :dose_qty
      t.string :unit
      t.text :instructions

      t.timestamps
    end
  end
end
