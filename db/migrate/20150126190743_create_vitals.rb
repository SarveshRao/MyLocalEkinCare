class CreateVitals < ActiveRecord::Migration
  def change
    create_table :vitals do |t|
      t.integer :customer_id
      t.integer :vital_list_id
      t.float :value

      t.timestamps
    end
  end
end
