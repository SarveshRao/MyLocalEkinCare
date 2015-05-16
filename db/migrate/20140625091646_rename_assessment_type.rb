class RenameAssessmentType < ActiveRecord::Migration
  def change
    rename_column :health_assessments, :type, :assessment_type
  end
end
