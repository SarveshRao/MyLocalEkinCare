class AddNewColumnToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :is_under_weight, :string
  end
end
