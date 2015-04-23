class AddUrlFileNameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :url, :string
    add_column :activities, :file_name, :string
  end
end
