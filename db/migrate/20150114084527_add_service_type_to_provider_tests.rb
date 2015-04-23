class AddServiceTypeToProviderTests < ActiveRecord::Migration
  def change
    add_column :provider_tests, :service_type, :string
  end
end
