class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :recommended_test
      t.string :frequency
      t.date :consult_date
      t.integer :recommend_id
      t.string :recommend_type

      t.timestamps
    end
  end
end
