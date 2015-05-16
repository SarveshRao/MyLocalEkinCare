class AddCustomerAddressToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :customer_address, :boolean, default: false
  end
end
