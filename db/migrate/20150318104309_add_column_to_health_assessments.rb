class AddColumnToHealthAssessments < ActiveRecord::Migration
  def change
    add_column :health_assessments, :enterprise_id, :integer
  end
end
