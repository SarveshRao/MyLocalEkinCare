class AddGuardianIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :guardian_id, :integer
  end
end
