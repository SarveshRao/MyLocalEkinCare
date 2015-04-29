class AddPromoCodeToHealthAssessment < ActiveRecord::Migration
  def change
    add_column :health_assessments, :promo_code_id, :integer
  end
end
