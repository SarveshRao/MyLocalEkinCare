class AddCodeToHealthAssessmentPromoCode < ActiveRecord::Migration
  def change
    add_column :health_assessment_promo_codes, :code, :string
  end
end
