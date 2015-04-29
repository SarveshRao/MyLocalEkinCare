class RemovePromoCodeIdFromHealthAssessment < ActiveRecord::Migration
  def change
    remove_column :health_assessments, :promo_code_id, :integer
  end
end
