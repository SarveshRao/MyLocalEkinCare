class AddActiveToMedication < ActiveRecord::Migration
  def change
    add_column :medications, :active, :boolean
  end
end
