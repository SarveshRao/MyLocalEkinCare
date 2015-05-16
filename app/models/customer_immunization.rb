class CustomerImmunization < ActiveRecord::Base
  belongs_to :customer
  belongs_to :immunization
end
