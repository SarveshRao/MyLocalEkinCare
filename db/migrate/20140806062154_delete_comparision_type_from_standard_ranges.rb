class DeleteComparisionTypeFromStandardRanges < ActiveRecord::Migration
  def change
    remove_column :standard_ranges, :comparision_type
    remove_column :standard_ranges, :min
    remove_column :standard_ranges, :max
    remove_column :standard_ranges, :value
  end
end
