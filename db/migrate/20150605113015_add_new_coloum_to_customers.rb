class AddNewColoumToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :blood_sos_on_off, :integer
  end
end
