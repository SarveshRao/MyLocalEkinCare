class AddInfoToLabTests < ActiveRecord::Migration
  def change
    add_column :lab_tests, :info, :string
  end
end
