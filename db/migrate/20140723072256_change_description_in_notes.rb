class ChangeDescriptionInNotes < ActiveRecord::Migration
  def change
    change_column :notes, :description, :text
  end
end
