class AddColumnToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :is_mobile_number_verified, :integer
  end
end
