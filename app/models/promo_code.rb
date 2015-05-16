class PromoCode < ActiveRecord::Base

  #belongs_to :promotion
  #belongs_to :staff
  belongs_to :customer
  belongs_to :partner
  has_many :health_assessment_promo_codes
  has_many :health_assessments, :through=>:health_assessment_promo_codes
  validates :code ,uniqueness:true
end
