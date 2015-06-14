class Staff::ProvidersController < StaffController
  before_action :staff_authenticated,:enterprises_active, :dashboard_active
  layout 'staff'

  # add_breadcrumb 'Providers'

  def index
    @staff = current_staff
    if params[:enterprise_id].nil?
      @enterprise_id = @staff.admin_id
    else
      @enterprise_id = params[:enterprise_id]
    end
    session[:selected_enterprise_id] = @enterprise_id
    #Rails.logger.debug("enterprise ID :#{@enterprise_id.inspect}")
    @providers = Provider.where("enterprise_id= #{@enterprise_id} and provider_id!=''")
    @provider_test = ProviderTest.joins("inner join enterprises on enterprises.id=provider_tests.provider_id where enterprises.id=#{@enterprise_id} ")
    @provider_test.each do |type|
      type.class_eval do
        attr_accessor :service_type1
        attr_accessor :service_type2
        attr_accessor :service_type3
      end
    end
    @provider_test.each do |type|
      @service_type = type.service_type
      if @service_type
        if @service_type[0] == "B"
          type.service_type1 = @service_type[0]
        elsif @service_type[0] == "D"
          type.service_type2 = @service_type[0]
        elsif @service_type[0] == "V"
          type.service_type3 = @service_type[0]
        end
        if @service_type[2] == "B"
          type.service_type1 = @service_type[2]
        elsif @service_type[2] == "D"
          type.service_type2 = @service_type[2]
        elsif @service_type[2] == "V"
          type.service_type3 = @service_type[2]
        end
        if @service_type[4] == "B"
          type.service_type1 = @service_type[4]
        elsif @service_type[4] == "D"
          type.service_type2 = @service_type[4]
        elsif @service_type[4] == "V"
          type.service_type3 = @service_type[4]
        end
      end
    end
    @branches = Provider.where("enterprise_id= #{@enterprise_id} and provider_id!=''").order('provider_id ASC')
    @enterprise = Enterprise.find(@enterprise_id)
    #@staff = Staff.find_by_admin_id(@enterprise_id)

    if session[:login_type] == 'Enterprise'
      add_breadcrumb 'Home', :staff_enterprise_login_path
      add_breadcrumb 'Branches'
      render "staff/providers/branches"
    else
      add_breadcrumb 'Home', :staff_staff_charts_index_path
      add_breadcrumb 'Enterprises', :staff_enterprises_path
      add_breadcrumb @enterprise.name
    end
  end

  def new
    @provider = Provider.new
    id = Provider.where("enterprise_id = #{session[:selected_enterprise_id]} and  provider_id !=''").order("id desc").limit(1).pluck("provider_id")
    enterprise_id = Enterprise.find(session[:selected_enterprise_id]).enterprise_id
    if id.empty?
      new_id = enterprise_id + 1.to_s
    else
      number = id[0].delete enterprise_id
      number = number.to_i
      new_id = enterprise_id + (number + 1).to_s
    end
    @provider.provider_id = new_id
    respond_to do |format|
      format.html { render "new", :layout => !request.xhr?, :locals => {:provider => @provider} }
    end
  end

  def edit
    @provider = Provider.find(params[:id])
    respond_to do |format|
      format.html { render "edit", :layout => !request.xhr?, :locals => {:provider => @provider} }
    end
  end

  def update
    @provider = Provider.find(params[:id])
    @provider.update provider_params
    @branches = Provider.where("enterprise_id = #{session[:selected_enterprise_id]} and  provider_id !=''").order('provider_id ASC')
    respond_to do |format|
      format.html { render "providerListing", :layout => !request.xhr?, :locals => {:branches => @branches} }
    end
  end

  def destroy
    Provider.destroy(params[:id])
    render json: {status: 'success'}, status: 200
  end

  def create
    @Provider =  Provider.new(provider_params)
    @Provider.enterprise_id = session[:selected_enterprise_id]
    @Provider.email = 'test1@provider.com'
    @Provider.staff.password = SecureRandom.hex(4)
    @Provider.save!
    # Notification.staff_account_notifier(@Provider.staff).deliver!
    @branches = Provider.where("enterprise_id = #{session[:selected_enterprise_id]} and  provider_id !=''").order('provider_id ASC')
    respond_to do |format|
      format.html { render "providerListing", :layout => !request.xhr?, :locals => {:branches => @branches} }
    end
  end

  def enterprises_active
    @enterprises_active = true
  end

  def provider_params
    params.require(:provider).permit(:provider_id, :id, :name, :telephone, :provider_type, :branch, :offline_number, staff_attributes: [:name, :id, :email], addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code])
  end

  def provider_address
    provider = Provider.find(params[:id])
    if !provider.addresses.empty?
      provider_address = provider.addresses.first.details
    else
      "Not specified"
    end

    if provider_address
      render json: {provider_address: provider_address}
    else
      render json:{msg: 'error'}, status: :not_found
    end

  end

  protected
  def dashboard_active
    @branch_active = true
  end


end
