class ChangeIndianNamesTypeInDrugs < ActiveRecord::Migration
  def change
    change_column :drugs, :indian_names, :text
  end
end
