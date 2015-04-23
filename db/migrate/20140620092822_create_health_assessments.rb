class CreateHealthAssessments < ActiveRecord::Migration
  def change
    create_table :health_assessments do |t|
      t.datetime :request_date
      t.string :type
      t.boolean :paid
      t.integer :customer_id

      t.timestamps
    end
  end
end
