class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :description
      t.integer :health_assessment_id

      t.timestamps
    end
  end
end
