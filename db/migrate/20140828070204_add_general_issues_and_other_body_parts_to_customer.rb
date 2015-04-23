class AddGeneralIssuesAndOtherBodyPartsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :general_issues, :text
    add_column :customers, :other_body_parts, :text
  end
end
