class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :code
      t.string :title
      t.string :poc
      t.text :description
      t.string :email
      t.string :mobile

      t.timestamps
    end
  end
end
