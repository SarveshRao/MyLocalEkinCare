class CreateVitalLists < ActiveRecord::Migration
  def change
    create_table :vital_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
