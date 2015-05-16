class RemoveHealthAssessmentIdFromPromoCode < ActiveRecord::Migration
  def change
    remove_column :promo_codes, :health_assessment_id, :string
  end
end
