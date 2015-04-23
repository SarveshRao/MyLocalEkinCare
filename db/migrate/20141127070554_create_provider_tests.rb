class CreateProviderTests < ActiveRecord::Migration
  def change
    create_table :provider_tests do |t|
      t.string :name
      t.string :description
      t.float :mrp
      t.float :cost
      t.float :discount
      t.integer :provider_id

      t.timestamps
    end
  end
end
