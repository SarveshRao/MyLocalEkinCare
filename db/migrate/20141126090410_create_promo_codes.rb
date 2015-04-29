class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.integer :customer_id
      t.integer :promotion_id
      t.integer :staff_id
      t.boolean :status

      t.timestamps
    end
  end
end
