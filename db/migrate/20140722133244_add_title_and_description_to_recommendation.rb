class AddTitleAndDescriptionToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :title, :string
    add_column :recommendations, :description, :text
  end
end
