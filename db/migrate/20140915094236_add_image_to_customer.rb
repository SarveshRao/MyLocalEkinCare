class AddImageToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :image, :string
  end
end
