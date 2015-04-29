class MedicalCondition < ActiveRecord::Base
  has_many :customer_medical_conditions
  has_many :customers, through: :customer_medical_conditions, autosave: true

  has_many :family_medical_conditions
  has_many :family_medical_histories, through: :family_medical_conditions, autosave: true
end
