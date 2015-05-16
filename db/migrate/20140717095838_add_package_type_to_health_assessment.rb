class AddPackageTypeToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :package_type, :string
  end
end
