class DropDentalResults < ActiveRecord::Migration
  def change
    drop_table :dental_results
  end
end
