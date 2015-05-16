class RemoveUrlFromMedicalRecord < ActiveRecord::Migration
  def change
    remove_column :medical_records, :url, :string
  end
end
