class DropVisionResults < ActiveRecord::Migration
  def change
    drop_table :vision_results
  end
end
