class Staff::CompaniesController < StaffController
  before_action :staff_authenticated,:companies_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path
  add_breadcrumb 'Companies', :staff_companies_path
  layout 'staff'

  def index
    @company = Company.all
  end

  def new
    @company = Company.new
    add_breadcrumb 'New'
  end

  def create
    @company =  Company.new(company_params)
    staff = Staff.find_by_email(@company.staff.email)
    if staff
      flash[:error] = "Email has already been taken"
      render js: "window.location='#{new_staff_company_path}'"
      # redirect_to new_staff_company_path
      # render "/staff/compannies/new"
      # render :status => 409, :text => "DUPLICATE_EMAIL"
    else
      @company.staff.password = SecureRandom.hex(4)
      if @company.save!
        Notification.staff_account_notifier(@company.staff).deliver!
        render js: "window.location='#{staff_companies_path}'"
      else
        redirect_to new_staff_company_path, notice: 'Sorry! Problem creating the Company'
      end
    end
  end

  def update
    @company = Company.find(params[:id])
    @company.update company_params
    respond_to do |format|
      format.html { render "show", :layout => !request.xhr?, :locals => {:company => @company} }
    end
  end

  def companies_active
    @companies_active = true
  end

  private
  def company_params
    params.require(:company).permit(:name, :telephone, staff_attributes: [:name, :id, :email],addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code])
  end

end
