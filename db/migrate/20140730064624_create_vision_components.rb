class CreateVisionComponents < ActiveRecord::Migration
  def change
    create_table :vision_components do |t|
      t.string :ucva
      t.string :cylindrical
      t.string :spherical
      t.string :axis
      t.string :prism
      t.string :add
      t.string :cva
      t.references :correction, index: true

      t.timestamps
    end
  end
end
