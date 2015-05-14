class CreateDoctorComments < ActiveRecord::Migration
  def change
    create_table :doctor_comments do |t|
      t.integer :customer_id
      t.string :doctor_name
      t.string :doctor_mobile_number
      t.string :doctor_email
      t.integer :notes_id
      t.string :genaral_comments

      t.timestamps
    end
  end
end
