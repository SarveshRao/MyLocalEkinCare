class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :procedure
      t.string :procedure_type

      t.timestamps
    end
  end
end
