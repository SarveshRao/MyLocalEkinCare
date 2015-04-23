class AddMobileNumberAndAlternativeMobileNumberToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :mobile_number, :string
    add_column :customers, :alternative_mobile_number, :string
  end
end
