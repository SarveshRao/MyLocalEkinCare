class DropHeightFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :height, :string
  end
end
