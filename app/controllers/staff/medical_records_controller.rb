class Staff::MedicalRecordsController < StaffController
  def create
    if params[:health_assessment_id].present?
      construct_health_assessment_record
    else
      construct_customer_record
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @medical_record = MedicalRecord.find(params[:id])
    @medical_record.remove_emr!
    @medical_record.delete

    render text: 'ok', status: 200
  end

  protected
  def construct_health_assessment_record
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    params[:files].each do |file|
      @medical_record = @health_assessment.medical_records.build(emr: file, title: params[:medical_record][:title], date: params[:medical_record][:date])
      @medical_record.save!
    end
  end

  def construct_customer_record
    @customer = Customer.find(params[:customer_id])
    assessment_id = params[:assessment_id]

    params[:files].each do |file|
      if assessment_id.empty?
        @medical_record = @customer.medical_records.build(emr: file, title: params[:medical_record][:title], date: params[:medical_record][:date])
      else
        health_assessment = HealthAssessment.find(assessment_id)
        @medical_record = health_assessment.medical_records.build(emr: file, title: params[:medical_record][:title], date: params[:medical_record][:date])
      end
      @medical_record.save!
    end
  end
end
