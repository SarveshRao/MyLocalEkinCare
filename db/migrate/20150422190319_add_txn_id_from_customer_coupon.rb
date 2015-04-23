class AddTxnIdFromCustomerCoupon < ActiveRecord::Migration
  def change
    add_column :customer_coupons, :txn_id, :string
  end
end
