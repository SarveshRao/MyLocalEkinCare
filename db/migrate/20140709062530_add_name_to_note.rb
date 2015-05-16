class AddNameToNote < ActiveRecord::Migration
  def change
    add_column :notes, :name, :string
  end
end
