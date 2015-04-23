class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.integer :customer_id
      t.datetime :date
      t.integer :drug_id
      t.integer :provider_id
      t.string :medication_type
      t.text :instructions

      t.timestamps
    end
  end
end
