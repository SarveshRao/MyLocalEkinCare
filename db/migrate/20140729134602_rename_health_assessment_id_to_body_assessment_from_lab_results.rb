class RenameHealthAssessmentIdToBodyAssessmentFromLabResults < ActiveRecord::Migration
  def change
    rename_column :lab_results, :health_assessment_id, :body_assessment_id
  end
end
