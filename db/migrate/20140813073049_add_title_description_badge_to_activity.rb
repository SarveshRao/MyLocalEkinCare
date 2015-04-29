class AddTitleDescriptionBadgeToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :title, :text
    add_column :activities, :description, :text
    add_column :activities, :badge, :string
  end
end
