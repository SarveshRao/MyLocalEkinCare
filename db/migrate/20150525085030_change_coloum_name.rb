class ChangeColoumName < ActiveRecord::Migration
  def change
    rename_column :doctor_comments, :genaral_comments, :general_comments
  end
end
