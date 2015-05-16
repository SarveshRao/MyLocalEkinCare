class AddPrescriberNameToMedication < ActiveRecord::Migration
  def change
    add_column :medications, :prescriber_name, :string
  end
end
