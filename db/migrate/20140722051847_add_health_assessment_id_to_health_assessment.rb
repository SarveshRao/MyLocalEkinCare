class AddHealthAssessmentIdToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :health_assessment_id, :string
  end
end
