class CreateWaterConsumptions < ActiveRecord::Migration
  def change
    create_table :water_consumptions do |t|
      t.integer :customer_id
      t.datetime :consumed_date
      t.string :water_consumed
      t.string :actual_consumption

      t.timestamps
    end
  end
end
