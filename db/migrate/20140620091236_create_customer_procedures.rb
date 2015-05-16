class CreateCustomerProcedures < ActiveRecord::Migration
  def change
    create_table :customer_procedures do |t|
      t.integer :customer_id
      t.integer :procedure_id
      t.date :date
      t.integer :provider_id

      t.timestamps
    end
  end
end
