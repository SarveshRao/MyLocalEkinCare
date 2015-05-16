class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :prefix
      t.string :title
      t.string :description
      t.date :start_date
      t.date :expiry_date
      t.integer :generate_codes
      t.integer :partner_id

      t.timestamps
    end
  end
end
