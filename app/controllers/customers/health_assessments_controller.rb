class Customers::HealthAssessmentsController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Health Assessments'
  #before_action :accessed_to_dashboard, only: :index

  def index
    @customer_health_assessment = true
    @id, @type ,@inbox_id= params[:id], params[:type],params[:inbox_id]
    unless(@inbox_id.nil?)
      @inbox=Inbox.find(@inbox_id)
      @inbox.update(status:true)
    end
    if @type == 'Body'
      @body_assessments = current_online_customer.health_assessments.body_assessment_done
      if @body_assessments.first
        @body_assessment = HealthAssessment.find(@body_assessments.first.id)
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
    @id, @type ,@inbox_id= params[:id], params[:type],params[:inbox_id]
    unless(@inbox_id.nil?)
      @inbox=Inbox.find(@inbox_id)
      @inbox.update(status:true)
    end
    if @type == 'Body'
      @body_assessments = current_online_customer.health_assessments.body_assessment_done
      @body_assessment = HealthAssessment.find(@id)
    elsif @type == 'Dental'
      dental_assessment
    elsif @type == 'Vision'
      vision_assessment
    end
    render "#{ @type.downcase }_assessment"
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
