class AddOtpSecretKeyToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :otp_secret_key, :string
  end
end
