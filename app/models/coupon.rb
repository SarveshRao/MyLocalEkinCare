class Coupon < ActiveRecord::Base
  has_many :customer_coupons
  has_many :customers , through: :customer_coupons, autosave: true
  belongs_to :coupon_source

  # scope :get_coupon, ->{where("is_used = ?", false).limit(1)}

  def is_valid_coupon?
    if(Time.now.between?(self.valid_from,self.expires_on))
      return true
    end
    return false
  end
end
