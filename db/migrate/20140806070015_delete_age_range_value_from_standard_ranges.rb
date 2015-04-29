class DeleteAgeRangeValueFromStandardRanges < ActiveRecord::Migration
  def change
    remove_column :standard_ranges, :age_range_value
  end
end
