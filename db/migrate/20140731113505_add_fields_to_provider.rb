class AddFieldsToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :provider_id, :string
    add_column :providers, :provider_type, :string
    add_column :providers, :branch, :string
    add_column :providers, :poc, :string
    add_column :providers, :offline_number, :string
    add_column :providers, :email, :string
  end
end
