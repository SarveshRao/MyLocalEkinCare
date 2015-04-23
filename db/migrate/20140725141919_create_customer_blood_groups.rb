class CreateCustomerBloodGroups < ActiveRecord::Migration
  def change
    create_table :customer_blood_groups do |t|
      t.integer :customer_id
      t.integer :blood_group_id

      t.timestamps
    end
  end
end
