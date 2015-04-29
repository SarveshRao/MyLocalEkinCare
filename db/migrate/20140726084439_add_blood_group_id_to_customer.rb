class AddBloodGroupIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :blood_group_id, :integer
  end
end
