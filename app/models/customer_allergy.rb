class CustomerAllergy < ActiveRecord::Base
  belongs_to :customer
  belongs_to :allergy
end
