class AddColumnToTestComponents < ActiveRecord::Migration
  def change
    add_column :test_components, :lonic_code, :string
  end
end
