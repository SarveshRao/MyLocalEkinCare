class CustomerMedicalCondition < ActiveRecord::Base
  belongs_to :customer
  belongs_to :medical_condition
end
