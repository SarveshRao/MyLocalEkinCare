class AddColumnToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :enterprise_id, :string
  end
end
