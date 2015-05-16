class RemoveEthnicityFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :ethnicity
  end
end
