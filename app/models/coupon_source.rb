class CouponSource < ActiveRecord::Base
  has_many :coupons


  def is_valid_coupon? code
    coupon=Coupon.find_by_code(code)
    if(coupon)
      self.coupons.include? coupon
    end
  end

end
