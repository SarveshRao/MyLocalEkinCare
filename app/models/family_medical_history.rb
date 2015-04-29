class FamilyMedicalHistory < ActiveRecord::Base
  belongs_to :customer
  has_many :family_medical_conditions
  has_many :medical_conditions, through: :family_medical_conditions, autosave: true

  default_scope ->{ order('created_at DESC')}

  def is_father?
    self.relation == 'Father'
  end

  def is_mother?
    self.relation == 'Mother'
  end

  def is_sibling?
    self.relation == 'Sibling'
  end

  def is_diabetic?
    return self.has_medical_condition?('Diabetic')
  end

  def has_hypertension?
    return self.has_medical_condition?('Hypertension')
  end

  protected
  def has_medical_condition? (name)
    unless(self.medical_conditions.nil?)
      diabetic=self.medical_conditions.where(name: name)
      if(diabetic.empty?)
        return false
      else
        return true
      end
    end
    return false
  end

end
