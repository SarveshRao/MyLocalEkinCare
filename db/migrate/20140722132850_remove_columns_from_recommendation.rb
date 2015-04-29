class RemoveColumnsFromRecommendation < ActiveRecord::Migration
  def change
    remove_column :recommendations, :recommended_test
    remove_column :recommendations, :frequency
    remove_column :recommendations, :consult_date
  end
end
