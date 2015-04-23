class CreateHealthAssessmentPromoCodes < ActiveRecord::Migration
  def change
    create_table :health_assessment_promo_codes do |t|
      t.integer :health_assessment_id
      t.integer :promo_code_id

      t.timestamps
    end
  end
end
