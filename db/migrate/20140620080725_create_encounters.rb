class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.string :encounter
      t.date :date
      t.integer :provider_id

      t.timestamps
    end
  end
end
