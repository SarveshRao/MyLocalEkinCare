class CreateCustomerVitals < ActiveRecord::Migration
  def change
    create_table :customer_vitals do |t|
      t.string :customer_id
      t.string :weight
      t.integer :blood_group_id
      t.integer :feet
      t.integer :inches

      t.timestamps
    end
  end
end
