class AddColumnToTestComponent < ActiveRecord::Migration
  def change
    add_column :test_components, :enterprise_id, :integer
  end
end
