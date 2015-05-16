class RenameImmunizationType < ActiveRecord::Migration
  def change
    rename_column :immunizations, :type ,:immunization_type
  end
end
