class CustomerCoupon < ActiveRecord::Base
  belongs_to :customer
  belongs_to :coupon

  validates :customer_id,:coupon_id,presence:true

  def is_coupon_used?
    if(self.txn_id.nil?)
      return false
    end
    return true
  end

  def is_coupon_applied?
    if(self.is_used)
      return true
    end
    return false
  end
end
