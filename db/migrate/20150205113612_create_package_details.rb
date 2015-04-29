class CreatePackageDetails < ActiveRecord::Migration
  def change
    create_table :package_details do |t|
      t.integer :customer_id
      t.integer :package_id
      t.float :amount
      t.datetime :appointment_body
      t.datetime :appointment_dental
      t.datetime :appointment_vision
      t.string :provider_body
      t.integer :provider_dental
      t.integer :provider_vision
      t.string :txnid

      t.timestamps
    end
  end
end
