class AddDefaultValueToActiveInMedication < ActiveRecord::Migration
  def change
    change_column :medications, :active, :boolean, :default => true
  end
end
