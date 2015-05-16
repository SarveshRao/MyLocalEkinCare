class RemoveStandardRangeFromTestComponents < ActiveRecord::Migration
  def change
    remove_column :test_components, :standard_range, :string
  end
end
