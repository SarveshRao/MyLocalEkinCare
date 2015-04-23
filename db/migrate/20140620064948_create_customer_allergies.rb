class CreateCustomerAllergies < ActiveRecord::Migration
  def change
    create_table :customer_allergies do |t|
      t.integer :customer_id
      t.integer :allergy_id
      t.string :severity

      t.timestamps
    end
  end
end
