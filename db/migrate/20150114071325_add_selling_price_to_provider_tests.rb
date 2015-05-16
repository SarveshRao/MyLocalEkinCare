class AddSellingPriceToProviderTests < ActiveRecord::Migration
  def change
    add_column :provider_tests, :selling_price, :float
  end
end
