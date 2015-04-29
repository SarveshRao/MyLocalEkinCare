class CreateMedicalConditions < ActiveRecord::Migration
  def change
    create_table :medical_conditions do |t|
      t.string :name
      t.string :info

      t.timestamps
    end
  end
end
