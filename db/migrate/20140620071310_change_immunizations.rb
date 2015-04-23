class ChangeImmunizations < ActiveRecord::Migration
  def change
    remove_column :immunizations, :date
    remove_column :immunizations, :dose_qty
    remove_column :immunizations, :unit
    remove_column :immunizations, :instructions
  end
end
