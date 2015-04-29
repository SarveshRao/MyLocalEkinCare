class RemoveSeverityFromAllergies < ActiveRecord::Migration
  def change
    remove_column :allergies, :severity
  end
end
