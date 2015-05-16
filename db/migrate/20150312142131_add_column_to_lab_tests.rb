class AddColumnToLabTests < ActiveRecord::Migration
  def change
    add_column :lab_tests, :enterprise_id, :integer
  end
end
