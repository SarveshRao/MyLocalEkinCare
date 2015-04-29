class AddRecordDateToMedicalRecord < ActiveRecord::Migration
  def change
    add_column :medical_records, :record_date, :date
  end
end
