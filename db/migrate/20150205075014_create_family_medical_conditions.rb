class CreateFamilyMedicalConditions < ActiveRecord::Migration
  def change
    create_table :family_medical_conditions do |t|
      t.integer :family_medical_history_id
      t.integer :medical_condition_id
      t.string :question

      t.timestamps
    end
  end
end
