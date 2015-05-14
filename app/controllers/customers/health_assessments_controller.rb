class Customers::HealthAssessmentsController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Health Assessments'
  #before_action :accessed_to_dashboard, only: :index

  def index
    @customer_health_assessment = true
    @id, @type ,@inbox_id= params[:id], params[:type],params[:inbox_id]
    @assessment_class='assessments'

    unless(@inbox_id.nil?)
      @inbox=Inbox.find(@inbox_id)
      @inbox.update(status:true)
    end
    @comments = DoctorComment.select("health_assessment_id, description, doctor_name, doctor_comments.created_at").joins("inner join notes on notes.id=doctor_comments.notes_id where doctor_comments.customer_id=#{current_online_customer.id}")
    # @comments = DoctorComment.includes(:note).where(customer_id: current_online_customer.id).all
    if @type == 'Body'
      @body_assessments = current_online_customer.health_assessments.body_assessment_done
      if @body_assessments.first
        @body_assessment = HealthAssessment.find(@body_assessments.first.id)
        @medical_records=@body_assessment.medical_records
      end
      # body_assessment
    elsif @type == 'Dental'
      dental_assessment
    elsif @type == 'Vision'
      vision_assessment
    end
    render "#{ @type.downcase }_assessment"
  end

  def show
    @customer_health_assessment = true
    @assessment_class='assessment'
    @id, @type ,@inbox_id= params[:id], params[:type],params[:inbox_id]
    @assessment_id=@id
    unless(@inbox_id.nil?)
      @inbox=Inbox.find(@inbox_id)
      @inbox.update(status:true)
    end
    @comments = DoctorComment.select("health_assessment_id, description, doctor_name, doctor_comments.created_at").joins("inner join notes on notes.id=doctor_comments.notes_id where doctor_comments.customer_id=#{current_online_customer.id}")
    if @type == 'Body'
      @body_assessments = current_online_customer.health_assessments.body_assessment_done
      @body_assessment = HealthAssessment.find(@id)
      @medical_records=@body_assessment.medical_records
    elsif @type == 'Dental'
      dental_assessment
    elsif @type == 'Vision'
      vision_assessment
    end
    render "#{ @type.downcase }_assessment"
  end

  def doctor_comment
    # Insert into note
    notes = Note.create(description: params[:notes], health_assessment_id: params[:body_assessment_id])
    # Insert into Comments
    @doctor_comment = DoctorComment.new
    @doctor_comment.doctor_name = session[:doctor_name]
    @doctor_comment.doctor_mobile_number = session[:doctor_mobile_number]
    @doctor_comment.doctor_email = session[:doctor_email]
    @doctor_comment.notes_id = notes.id
    @doctor_comment.customer_id = current_online_customer.id
    @doctor_comment.save
    redirect_to :back
  end

  protected
  def body_assessment
    page_no = page_no_picker || params[:page]
    @body_assessment = current_online_customer.health_assessments.body_assessment_done.page(page_no).per(1)
  end

  def dental_assessment
    page_no = page_no_picker || params[:page]
    @dental_assessment = current_online_customer.health_assessments.dental_assessment_done.page(page_no).per(1)

  end

  def vision_assessment
    page_no = page_no_picker || params[:page]
    @vision_assessment = current_online_customer.health_assessments.vision_assessment_done.page(page_no).per(1)
  end

  #Picks an appropriate page, based on assessment
  def page_no_picker
    if @id
      index = current_online_customer.assessment_index @type, @id
      page_no = index + 1
      return page_no
    end
    nil
  end
end
