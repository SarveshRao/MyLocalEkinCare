class AddPrism2AndUnits2ToVisionComponent < ActiveRecord::Migration
  def change
    add_column :vision_components, :prism2, :string
    add_column :vision_components, :units2, :string
  end
end
