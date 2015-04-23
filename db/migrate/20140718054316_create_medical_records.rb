class CreateMedicalRecords < ActiveRecord::Migration
  def change
    create_table :medical_records do |t|
      t.string :title
      t.string :record_type
      t.string :url
      t.string :record_type
      t.integer :record_id

      t.timestamps
    end
  end
end
