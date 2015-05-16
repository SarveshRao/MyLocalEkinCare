class Staff::StaffChartsController < StaffController
  include ApplicationHelper
  before_action :charts_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path
  def index
    @customers=Customer.all
    @total_customer_count=@customers.count
    # @customers_at_your_health_stage=Customer.where(status: 'your_health').count
    # @customers_at_upload_documents_stage=Customer.where(status:'upload_documents').count
    # @customers_at_thank_you_page_stage=Customer.where(status:'thank_you_page').count

    # @not_done_state_assessments=HealthAssessment.where.not(status:'done').count
    # @total_assessments=HealthAssessment.all.count
    # @percentage_of_not_done_assessments=get_percentage(@not_done_state_assessments,@total_assessments)

    # @unverified_email_count=Customer.where.not(confirmation_token: nil).count
    # @verified_email_count=@total_customer_count-@unverified_email_count
    # @percentage_of_unverified=get_percentage(@unverified_email_count,@total_customer_count)

    # bps=Array.new
    # @customers.each do |customer|
    #   if(customer.abnormal_bp == true)
    #     bps.push(customer)
    #   end
    # end
    # @number_of_customers_who_have_abnormal_bp=bps.count()
    # @percentage_with_bps=get_percentage(@number_of_customers_who_have_abnormal_bp,@total_customer_count)

    add_breadcrumb 'Charts'
  end

  def assessments_not_done
    @not_done_state_assessments=HealthAssessment.where.not(status:'done').count
    @total_assessments=HealthAssessment.all.count
    @percentage_of_not_done_assessments=get_percentage(@not_done_state_assessments,@total_assessments)

    render json: {not_done_percentage: @percentage_of_not_done_assessments, not_done_count: @not_done_state_assessments}
  end

  def unverified_emails
    @total_customer_count=Customer.all.count
    @unverified_email_count=Customer.where.not(confirmation_token: nil).count
    @percentage_of_unverified=get_percentage(@unverified_email_count,@total_customer_count)

    render json: {unverified_email_percentage: @percentage_of_unverified, unverified_email_count: @unverified_email_count}
  end

  def abnormal_bp
    @customer = Customer.all
    bps=Array.new
    @customer.each do |customer|
      if(customer.abnormal_bp == true)
        bps.push(customer)
      end
    end
    @total_customer_count=@customer.count
    @number_of_customers_who_have_abnormal_bp=bps.count()
    @percentage_with_bps=get_percentage(@number_of_customers_who_have_abnormal_bp,@total_customer_count)

    render json: {abnormal_bp_percentage: @percentage_with_bps, abnormal_bp_count: @number_of_customers_who_have_abnormal_bp}
  end

  protected
  def charts_active
    @charts_active=true
  end
end