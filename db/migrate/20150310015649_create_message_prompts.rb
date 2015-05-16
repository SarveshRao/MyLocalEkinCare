class CreateMessagePrompts < ActiveRecord::Migration
  def change
    create_table :message_prompts do |t|
      t.integer :risk_factor_id
      t.string :gender
      t.string :range
      t.string :message
      t.string :image

      t.timestamps
    end
  end
end
