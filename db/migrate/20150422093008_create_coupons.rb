class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.float :price
      t.integer :no_of_users_used
      t.datetime :valid_from
      t.datetime :expires_on

      t.timestamps
    end
  end
end
