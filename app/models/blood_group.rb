class BloodGroup < ActiveRecord::Base
  has_one :customer
  has_one :customer_vitals
  has_one :vital
end
