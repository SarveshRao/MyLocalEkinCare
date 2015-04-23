class AddTypeToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :type, :string
  end
end
