class AddCurrentPreviousStateToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :current_state, :string
    add_column :activities, :previous_state, :string
  end
end
