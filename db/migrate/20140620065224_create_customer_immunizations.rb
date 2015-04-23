class CreateCustomerImmunizations < ActiveRecord::Migration
  def change
    create_table :customer_immunizations do |t|
      t.integer :customer_id
      t.integer :immunization_id
      t.date :date
      t.string :dosage
      t.text :instructions

      t.timestamps
    end
  end
end
