class AddDoctorNameToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :doctor_name, :string
  end
end
