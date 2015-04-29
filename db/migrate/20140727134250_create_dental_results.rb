class CreateDentalResults < ActiveRecord::Migration
  def change
    create_table :dental_results do |t|
      t.integer :health_assessment_id
      t.integer :test_component_id
      t.string :result

      t.timestamps
    end
  end
end
