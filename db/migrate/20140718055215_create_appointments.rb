class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.date :appointment_date
      t.time :time
      t.string :description
      t.string :appointment_type
      t.integer :appointmentee_id
      t.string :appointmentee_type

      t.timestamps
    end
  end
end
