class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :is_hypertensive, :string
    add_column :customers, :diabetic, :string
    add_column :customers, :is_obese, :string
    add_column :customers, :is_over_weight, :string
  end
end
