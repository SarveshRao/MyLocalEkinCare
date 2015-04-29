class AddNameToMedication < ActiveRecord::Migration
  def change
    add_column :medications, :name, :string
  end
end
