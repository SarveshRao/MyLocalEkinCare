class AddColumnToStandardRange < ActiveRecord::Migration
  def change
    add_column :standard_ranges, :enterprise_id, :integer
  end
end
