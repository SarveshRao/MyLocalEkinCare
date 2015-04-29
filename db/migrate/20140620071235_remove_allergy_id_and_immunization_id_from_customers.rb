class RemoveAllergyIdAndImmunizationIdFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :allergy_id
    remove_column :customers, :immunization_id
  end
end
