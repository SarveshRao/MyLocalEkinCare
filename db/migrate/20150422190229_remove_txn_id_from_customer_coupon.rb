class RemoveTxnIdFromCustomerCoupon < ActiveRecord::Migration
  def change
    remove_column :customer_coupons, :txn_id, :integer
  end
end
