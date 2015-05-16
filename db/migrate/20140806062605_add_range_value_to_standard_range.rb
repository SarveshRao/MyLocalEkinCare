class AddRangeValueToStandardRange < ActiveRecord::Migration
  def change
    add_column :standard_ranges, :range_value, :string
  end
end
