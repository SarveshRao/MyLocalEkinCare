class CreateCustomerCoupons < ActiveRecord::Migration
  def change
    create_table :customer_coupons do |t|
      t.integer :customer_id
      t.integer :coupon_id
      t.boolean :is_used

      t.timestamps
    end
  end
end
