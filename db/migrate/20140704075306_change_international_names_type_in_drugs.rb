class ChangeInternationalNamesTypeInDrugs < ActiveRecord::Migration
  def change
    change_column :drugs, :international_names, :text
  end
end
