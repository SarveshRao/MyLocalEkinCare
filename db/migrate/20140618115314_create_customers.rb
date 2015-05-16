class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :martial_status
      t.string :religious_affiliation
      t.string :ethnicity
      t.string :language_spoken
      t.string :email
      t.date :date_of_birth
      t.references :allergy, index: true
      t.references :immunization, index: true

      t.timestamps
    end
  end
end
