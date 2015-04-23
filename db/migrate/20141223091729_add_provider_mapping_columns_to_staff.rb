class AddProviderMappingColumnsToStaff < ActiveRecord::Migration
  def change
    add_column :staff, :admin_id, :integer
    add_column :staff, :admin_type, :string
  end
end
