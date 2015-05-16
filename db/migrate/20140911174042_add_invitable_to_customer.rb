class AddInvitableToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :invitation_token, :string
    add_column :customers, :invitation_created_at, :datetime
    add_column :customers, :invitation_sent_at, :datetime
    add_column :customers, :invitation_accepted_at, :datetime
    add_column :customers, :invitation_limit, :integer
    add_index :customers, :invitation_token, :unique => true
  end
end
