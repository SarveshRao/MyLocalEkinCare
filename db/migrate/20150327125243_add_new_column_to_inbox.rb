class AddNewColumnToInbox < ActiveRecord::Migration
  def change
    add_column :inboxes, :status, :boolean
  end
end
