class AddWizardStatusToCustomerVitals < ActiveRecord::Migration
  def change
    add_column :customer_vitals, :wizard_status, :string
  end
end
