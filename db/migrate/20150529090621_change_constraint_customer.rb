class ChangeConstraintCustomer < ActiveRecord::Migration
  def change
    remove_index :customers, column: :email
  end
end
