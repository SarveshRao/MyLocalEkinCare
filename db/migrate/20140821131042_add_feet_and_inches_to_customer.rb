class AddFeetAndInchesToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :feet, :integer
    add_column :customers, :inches, :integer
  end
end
