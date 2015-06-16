class AddNewColumnToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :sponsor, :integer
  end
end
