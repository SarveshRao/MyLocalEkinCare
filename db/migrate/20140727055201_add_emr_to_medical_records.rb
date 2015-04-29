class AddEmrToMedicalRecords < ActiveRecord::Migration
  def change
    add_column :medical_records, :emr, :string
  end
end
