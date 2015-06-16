class AddNewColumnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :telephone, :string
  end
end
