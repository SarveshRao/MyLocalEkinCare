class CreateLabResults < ActiveRecord::Migration
  def change
    create_table :lab_results do |t|
      t.integer :health_assessment_id
      t.integer :test_component_id
      t.string :result

      t.timestamps
    end
  end
end
