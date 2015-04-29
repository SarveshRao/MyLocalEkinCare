class AddUnitsToVisionComponent < ActiveRecord::Migration
  def change
    add_column :vision_components, :units, :string
  end
end
