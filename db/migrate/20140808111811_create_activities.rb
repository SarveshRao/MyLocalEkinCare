class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.string :fields
      t.string :action
      t.text :text
      t.integer :associated_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
