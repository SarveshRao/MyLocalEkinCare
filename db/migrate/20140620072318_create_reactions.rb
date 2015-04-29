class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :allergy_id
      t.string :reaction

      t.timestamps
    end
  end
end
