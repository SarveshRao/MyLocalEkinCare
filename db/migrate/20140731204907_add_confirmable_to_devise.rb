class AddConfirmableToDevise < ActiveRecord::Migration
  # Note: You can't use change, as Customer.update_all with fail in the down migration
  def self.up
    add_column :customers, :confirmation_token, :string
    add_column :customers, :confirmed_at, :datetime
    add_column :customers, :confirmation_sent_at, :datetime
    # add_column :customers, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :customers, :confirmation_token, :unique => true
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # customers as confirmed, do the following
    # All existing user accounts should be able to log in after this.
  end

  def self.down
    remove_columns :customers, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
