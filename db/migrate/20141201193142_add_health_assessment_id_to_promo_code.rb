class AddHealthAssessmentIdToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :health_assessment_id, :string
  end
end
