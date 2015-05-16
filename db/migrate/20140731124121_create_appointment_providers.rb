class CreateAppointmentProviders < ActiveRecord::Migration
  def change
    create_table :appointment_providers do |t|
      t.integer :provider_id
      t.integer :appointment_id
    end
  end
end
