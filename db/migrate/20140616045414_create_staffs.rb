class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :email
      t.string :password_salt
      t.string :password_hash

      t.timestamps
    end
  end
end
