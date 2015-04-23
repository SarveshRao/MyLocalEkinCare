class CreateExaminations < ActiveRecord::Migration
  def change
    create_table :examinations do |t|
      t.integer :dental_assessment_id

      t.timestamps
    end
  end
end