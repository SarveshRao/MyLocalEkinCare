class CreateAllergies < ActiveRecord::Migration
  def change
    create_table :allergies do |t|
      t.string :name
      t.string :reaction
      t.string :severity

      t.timestamps
    end
  end
end
