class CreateLabTests < ActiveRecord::Migration
  def change
    create_table :lab_tests do |t|
      t.string :name

      t.timestamps
    end
  end
end
