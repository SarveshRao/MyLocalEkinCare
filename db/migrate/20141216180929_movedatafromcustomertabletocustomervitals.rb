class Movedatafromcustomertabletocustomervitals < ActiveRecord::Migration
  def change
    execute "INSERT INTO customer_vitals (customer_id, weight, blood_group_id, feet, inches, created_at, updated_at) SELECT id, weight, blood_group_id, feet, inches, created_at, updated_at FROM customers"
  end
end
