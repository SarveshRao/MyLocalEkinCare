class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.integer :vision_assessment_id
      t.string :lens_type

      t.timestamps
    end
  end
end
