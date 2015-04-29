class AddAgeFieldsToStandardRanges < ActiveRecord::Migration
  def change
    add_column :standard_ranges, :age_limit, :string
    add_column :standard_ranges, :age_range_value, :string
  end
end
