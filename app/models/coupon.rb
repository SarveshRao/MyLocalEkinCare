class Coupon < ActiveRecord::Base
  has_many :customer_coupons
  has_many :customers , through: :customer_coupons, autosave: true

  # scope :get_coupon, ->{where("is_used = ?", false).limit(1)}
end
