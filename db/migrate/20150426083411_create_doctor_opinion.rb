class CreateDoctorOpinion < ActiveRecord::Migration
  def change
    create_table :doctor_opinions do |t|
      t.integer :customer_id
      t.string :doctor_name
      t.string :doctor_mobile_number
      t.string :doctor_email
      t.string :otp_secret_key

      t.timestamps
    end
  end
end
