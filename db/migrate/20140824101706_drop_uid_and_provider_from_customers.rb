class DropUidAndProviderFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :uid
    remove_column :customers, :provider
  end
end
