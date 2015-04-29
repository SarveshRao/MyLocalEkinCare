class AddAssociatedDateToInbox < ActiveRecord::Migration
  def change
    add_column :inboxes, :associated_date, :date
  end
end
