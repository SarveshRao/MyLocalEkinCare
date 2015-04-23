class RemoveComponentFromCorrection < ActiveRecord::Migration
  def change
    remove_column :corrections, :component, :string
  end
end
