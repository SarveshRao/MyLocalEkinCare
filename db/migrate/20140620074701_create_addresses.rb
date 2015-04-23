class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :addressee_id
      t.string :addressee_type

      t.timestamps
    end
  end
end
