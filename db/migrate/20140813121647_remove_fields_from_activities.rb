class RemoveFieldsFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :fields, :string
    remove_column :activities, :current_state, :string
    remove_column :activities, :previous_state, :string
  end
end
