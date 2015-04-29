class AddInfoToTestComponent < ActiveRecord::Migration
  def change
    add_column :test_components, :info, :text
  end
end
