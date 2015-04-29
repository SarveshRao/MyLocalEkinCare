class AddRateDoseToMedication < ActiveRecord::Migration
  def change
    add_column :medications, :rate_quantity, :string
    add_column :medications, :dose_quantity, :string
  end
end
