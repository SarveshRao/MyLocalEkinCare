class AddAssessmentActivityIdToTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :assessment_activity_id, :string
    add_column :timelines, :integer, :string
  end
end
