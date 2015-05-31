class AddColoumsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :hydrocare_subscripted, :integer
    add_column :customers, :blood_sos_subscripted, :integer
  end
end
