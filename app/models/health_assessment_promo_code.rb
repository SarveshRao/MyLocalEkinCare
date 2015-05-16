class HealthAssessmentPromoCode < ActiveRecord::Base
  belongs_to :health_assessment
  belongs_to :promo_code
  validates :health_assessment_id,:promo_code_id,presence:true
end
