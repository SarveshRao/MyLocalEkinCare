class Timeline < ActiveRecord::Base
  belongs_to :customer

  default_scope { where("activity_type in (?) OR assessment_activity_id = ?", ['BodyAssessment', 'DentalAssessment', 'VisionAssessment', 'HealthAssessment'], '0').order('updated_at DESC') }

  def associated_medical_records
    Timeline.unscoped.where("assessment_activity_id = ? and activity_type=?", self.associated_id.to_s, "MedicalRecord")
  end

  def assessment
    begin
      assessment = HealthAssessment.find(self.associated_id)
    rescue
    end
    assessment
  end

  def assessment_date
    begin
      assessment = HealthAssessment.find(self.associated_id)
      assessment_date = assessment.request_date
    rescue
      assessment_date = nil
    end
    assessment_date
  end

end
