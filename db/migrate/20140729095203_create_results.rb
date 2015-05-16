class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :examination_id
      t.string :dentition
      t.integer :tooth_number
      t.text :diagnosis
      t.text :recommendation

      t.timestamps
    end
  end
end
