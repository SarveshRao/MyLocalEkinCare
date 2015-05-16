class AddAgeGenderFieldsToStandardRanges < ActiveRecord::Migration
  def change
    add_column :standard_ranges, :age_male_range_value, :string
    add_column :standard_ranges, :age_female_range_value, :string
  end
end
