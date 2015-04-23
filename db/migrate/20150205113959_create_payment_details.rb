class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.string :txnid
      t.string :status
      t.float :amount
      t.string :mihpayid
      t.string :mode
      t.float :discount
      t.string :checksum
      t.string :error
      t.string :pg_type
      t.string :bank_ref_num
      t.string :unmappedstatus
      t.string :payumoney_id
      t.integer :package_id

      t.timestamps
    end
  end
end
