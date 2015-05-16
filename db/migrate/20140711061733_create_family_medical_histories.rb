class CreateFamilyMedicalHistories < ActiveRecord::Migration
  def change
    create_table :family_medical_histories do |t|
      t.string :name
      t.string :relation
      t.integer :age
      t.string :status
      t.string :medical_condition_1
      t.string :medical_condition_2
      t.string :medical_condition_3
      t.integer :customer_id

      t.timestamps
    end
  end
end
