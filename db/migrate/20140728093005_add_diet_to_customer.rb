class AddDietToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :diet, :string
  end
end
