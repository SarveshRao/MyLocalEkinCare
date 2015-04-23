class AddStatusToHealthAssessments < ActiveRecord::Migration
  def change
    add_column :health_assessments, :status, :string
  end
end
