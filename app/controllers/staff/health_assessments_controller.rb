class Staff::HealthAssessmentsController < StaffController
  include ApplicationHelper
  before_action :staff_authenticated, :health_assessment_active
  layout 'staff'

  def create
    status_code = HealthAssessment::STATES.index(params[:health_assessment][:status])
    @customer = Customer.includes(:health_assessments).find(params[:customer_id])
    if params[:health_assessment][:enterprise_id]
      @enterprise = Enterprise.find(params[:health_assessment][:enterprise_id])
      enterprise_name = @enterprise.name
    end
    @health_assessment = @customer.health_assessments.create!(health_assessment_params) do |ha|
      ha.status_code = status_code
    end

    @enterprise_all = Enterprise.all
    assessment_requested_date = formatted_date @health_assessment.request_date
    parsed_date = numeric_date_format @health_assessment.request_date
    render json: { enterprise: @enterprise_all, enterprise_name: enterprise_name, health_assessment: @health_assessment, request_date: assessment_requested_date, customer_id: @customer.id, parsed_date: parsed_date, status_message: @health_assessment.status_message }
  end

  def update
    @customer = Customer.find(params[:customer_id])
    status_code = HealthAssessment::STATES.index(params[:health_assessment][:status])
    @health_assessments = @customer.health_assessments
    @customer_health_assessment = @health_assessments.find(params[:id])
    if params[:health_assessment][:enterprise_id]
      @enterprise = Enterprise.find(params[:health_assessment][:enterprise_id])
      enterprise_name = @enterprise.name
    end
    @customer_health_assessment.update(health_assessment_params) do |cha|
      cha.status_code = status_code
    end

    assessment_requested_date = formatted_date @customer_health_assessment.request_date
    render json: { enterprise_name: enterprise_name, health_assessment: @customer_health_assessment, request_date: assessment_requested_date, customer_id: @customer.id, status_message: @customer_health_assessment.status_message }
  end

  def index
    @assessments = HealthAssessment.unscoped.all.requested

    if session[:login_type] == 'Enterprise'
      add_breadcrumb 'Home', :staff_enterprise_login_path
      add_breadcrumb 'Customers', :staff_customer_enterprise_index_path
      add_breadcrumb 'Assessments'
    elsif session[:login_type] == 'Provider'
      add_breadcrumb 'Home', :staff_provider_login_path
      add_breadcrumb 'Customers', :staff_customer_provider_index_path
      add_breadcrumb 'Assessments'
    else
      add_breadcrumb 'Home', :staff_staff_charts_index_path
      add_breadcrumb 'Customers', :customers_path
      add_breadcrumb 'Assessments'
    end

  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    assessment = @customer.health_assessments.find(params[:id])
    assessment.destroy

    render json: { success: 'success' }, status: 200
  end

  def show
    @customer = Customer.includes([:health_assessments]).find(params[:customer_id])
    @health_assessment = @customer.health_assessments.find(params[:id])
    if @health_assessment.enterprise_id
      @enterprise = Enterprise.find(@health_assessment.enterprise_id)
      @health_assessment.enterprise_name = @enterprise.name
    else
      @health_assessment.enterprise_name = ''
    end
    @recommendations = @health_assessment.recommendations
    @notes = @health_assessment.notes

    if session[:login_type] == 'Enterprise'
      add_breadcrumb 'Home', :staff_enterprise_login_path
      add_breadcrumb 'Customers', :staff_customer_enterprise_index_path
      add_breadcrumb @customer.name, staff_customer_enterprise_path(@customer)
      add_breadcrumb 'Assessments', staff_customer_enterprise_path(@customer)
      add_breadcrumb @health_assessment.health_assessment_id
    elsif session[:login_type] == 'Provider'
      add_breadcrumb 'Home', :staff_provider_login_path
      add_breadcrumb 'Customers', :staff_customer_provider_index_path
      add_breadcrumb @customer.name, staff_customer_provider_path(@customer)
      add_breadcrumb 'Assessments', staff_customer_provider_path(@customer)
      add_breadcrumb @health_assessment.health_assessment_id
    else
      add_breadcrumb 'Home', :staff_staff_charts_index_path
      add_breadcrumb 'Customers', :customers_path
      add_breadcrumb @customer.name, customer_path(@customer)
      add_breadcrumb 'Assessments', customer_path(@customer)
      add_breadcrumb @health_assessment.health_assessment_id
    end

    respond_to do |format|
      format.json {render json: @health_assessment}
      format.html
    end
  end

  def all
    @health_assessments = HealthAssessment.all.includes(:customer).unscoped.order('status_code ASC')
    puts @health_assessments.inspect
    render json: { draw: 1, recordsTotal: @health_assessments.count, recordsFiltered: 57, aaData: data(@health_assessments) }
  end

  protected

  def health_assessment_params
    params.require(:health_assessment).permit(:request_date, :assessment_type, :paid, :status, :package_type,:doctor_name, :enterprise_id, :provider_name)
  end

  def data(health_assessments)
    @health_assessments = health_assessments.inject([]) do |array, assessment|
      # paid_status = "<a class=active href=#><i class='fa #{assessment.paid ? 'fa-check text-success' : 'fa-times text-danger'} text-active'></i></a>"
      request_date = formatted_date assessment.request_date
      customer = assessment.customer
      array.push({
                     id: customer.id.to_i,
                     request_date: formatted_date(assessment.request_date),
                     name: customer.name,
                     type: customer.customer_type,
                     mobile_number: customer.mobile_number,
                     date: request_date,
                     assessment_type: assessment.assessment_type,
                     package_type: assessment.package_type,
                     status: assessment.status,
                     status_message: assessment.status_message,
                     customer_id: customer.customer_id,
                     url: "/customers/#{customer.id}"
                 })
    end
  end

  def health_assessment_active
    @health_assessment_active = true
  end
end
