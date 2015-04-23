class AddWaistToCustomerVitals < ActiveRecord::Migration
  def change
    add_column :customer_vitals, :waist, :float
  end
end
