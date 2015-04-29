class CreateCustomerMedicalConditions < ActiveRecord::Migration
  def change
    create_table :customer_medical_conditions do |t|
      t.integer :customer_id
      t.integer :medical_condition_id
      t.string :question

      t.timestamps
    end
  end
end
