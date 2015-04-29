class AddEnterpriseidToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :enterprise_id, :integer
  end
end
