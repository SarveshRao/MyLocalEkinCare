class AddTransactionIdToCustomerCoupon < ActiveRecord::Migration
  def change
    add_column :customer_coupons, :txn_id, :integer
  end
end
