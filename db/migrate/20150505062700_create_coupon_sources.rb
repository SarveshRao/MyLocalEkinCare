class CreateCouponSources < ActiveRecord::Migration
  def change
    create_table :coupon_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
