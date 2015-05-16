class DropCustomerBloodGroup < ActiveRecord::Migration
  def change
    drop_table :customer_blood_groups
  end
end
