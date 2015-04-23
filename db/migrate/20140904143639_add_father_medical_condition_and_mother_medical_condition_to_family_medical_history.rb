class AddFatherMedicalConditionAndMotherMedicalConditionToFamilyMedicalHistory < ActiveRecord::Migration
  def change
    add_column :family_medical_histories, :family_medical_condition, :string
    add_column :family_medical_histories, :mother_medical_condition, :string
  end
end
