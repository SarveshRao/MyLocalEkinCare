class AddStatusCodeToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :status_code, :integer
  end
end
