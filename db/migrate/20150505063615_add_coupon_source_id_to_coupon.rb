class AddCouponSourceIdToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :coupon_source_id, :integer
  end
end
