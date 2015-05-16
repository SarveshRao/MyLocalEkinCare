class AddDateToMedicalRecord < ActiveRecord::Migration
  def change
    add_column :medical_records, :date, :date
  end
end
