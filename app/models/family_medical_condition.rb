class FamilyMedicalCondition < ActiveRecord::Base
  belongs_to :family_medical_history
  belongs_to :medical_condition
end
