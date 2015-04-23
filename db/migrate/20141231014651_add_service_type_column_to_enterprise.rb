class AddServiceTypeColumnToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :service_type, :string
  end
end
