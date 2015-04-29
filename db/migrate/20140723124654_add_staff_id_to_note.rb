class AddStaffIdToNote < ActiveRecord::Migration
  def change
    add_column :notes, :staff_id, :integer
  end
end
