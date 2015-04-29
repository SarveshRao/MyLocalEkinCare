class CreateInboxes < ActiveRecord::Migration
  def change
    create_table :inboxes do |t|
      t.string :activity_type
      t.string :action
      t.text :text
      t.integer :associated_id
      t.integer :customer_id
      t.string :title
      t.text :description
      t.string :badge
      t.text :url
      t.string :file_name

      t.timestamps
    end
  end
end
