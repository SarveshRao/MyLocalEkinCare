class Staff::ProviderTestsController < StaffController
  before_action :providers_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path
  add_breadcrumb 'Enterprises', :staff_enterprises_path
  add_breadcrumb 'prices'

  def index
    @providertest = ProviderTest.all
  end

  def new
    @enterprise_id = session[:selected_enterprise_id]
    @providertest = ProviderTest.new
    respond_to do |format|
      format.html { render "new", :layout => !request.xhr?, :locals => {:providertest => @providertest} }
    end
  end

  def create

    @enterprise_id = params[:enterprise_id]
    @service_type = params[:provider_test][:service_type].join(",")
    @providertest = ProviderTest.new(name: params[:provider_test][:name], mrp: params[:provider_test][:mrp], selling_price: params[:provider_test][:selling_price], service_type: @service_type, cost: params[:provider_test][:cost], discount: params[:provider_test][:discount], provider_id: params[:provider_test][:provider_id])
    @providertest.save
    @provider_test = ProviderTest.joins("inner join enterprises on enterprises.id=provider_tests.provider_id where enterprises.id=#{session[:selected_enterprise_id]} ")
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
    respond_to do |format|
      format.html { render "index", :layout => !request.xhr?, :locals => {:provider_test => @provider_test} }
    end
  end

  def update

    @providertest = ProviderTest.find(params[:id])
    @service_type = ""
    if params[:provider_test][:service_type1]
      @service_type = "B"
    end
    if params[:provider_test][:service_type2]
      if @service_type !=""
        @service_type = @service_type+",D"
      else
        @service_type = "D"
      end
    end
    if params[:provider_test][:service_type3]
      if @service_type !=""
        @service_type = @service_type+",V"
      else
        @service_type = "V"
      end
    end
    @providertest.update(name: params[:provider_test][:name], mrp: params[:provider_test][:mrp], selling_price: params[:provider_test][:selling_price], service_type: @service_type, cost: params[:provider_test][:cost], discount: params[:provider_test][:discount], provider_id: params[:provider_test][:provider_id])
    @providertest.save

    render partial: 'updated_provider_test'
  end

  def destroy
    ProviderTest.destroy(params[:id])
    render json: {status: 'success'}, status: 200
  end

  protected
  def providers_active
    @providers_active = true
  end

  protected
  def provider_test_param
    params.require(:provider_test).permit(:name, :mrp, :selling_price, :service_type, :cost, :discount, :provider_id)
  end

end
