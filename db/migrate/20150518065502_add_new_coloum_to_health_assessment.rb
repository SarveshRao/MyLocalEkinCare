class AddNewColoumToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :provider_name, :string
  end
end
