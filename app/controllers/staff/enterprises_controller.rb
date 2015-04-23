class Staff::EnterprisesController < StaffController
  before_action :staff_authenticated,:enterprises_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path
  add_breadcrumb 'Enterprises', :staff_enterprises_path
  layout 'staff'

  def index
    @enterprises = Enterprise.all
    #@enterprises = Enterprise.all
  end

  def new
    @enterprise = Enterprise.new
    add_breadcrumb 'New'
  end

  def create
    @enterprise =  Enterprise.new(enterprise_params)
    staff = Staff.find_by_email(@enterprise.staff.email)
    ent = Enterprise.find_by_enterprise_id(@enterprise.enterprise_id)
    if staff
      render :status => 409, :text => "DUPLICATE_EMAIL"
    elsif ent
      render :status => 409, :text => "DUPLICATE_ENTERPRISE_ID"
    else
      @enterprise.staff.password = SecureRandom.hex(4)
      if @enterprise.save!
        Notification.staff_account_notifier(@enterprise.staff).deliver!
        if @enterprise.service_type == 'Body'
          enterprise = Enterprise.find_by_enterprise_id('EK')
          @labtests = LabTest.where(enterprise_id: enterprise.id).order('id asc')
          @labtests.each do |test|
            @labtest = LabTest.new(name: test.name, info: test.info, enterprise_id: @enterprise.id)
            if @labtest.save!
              @testcomponents = TestComponent.where(lab_test_id: test.id).order('id asc')
              @testcomponents.each do |components|
                @testcomponent = TestComponent.new(name: components.name, units: components.units, lab_test_id: @labtest.id, info: components.info, enterprise_id: @enterprise.id)
                if @testcomponent.save!
                  @standardRanges = StandardRange.where(test_component_id: components.id).order('id asc')
                  @standardRanges.each do |standard|
                    @standardRange = StandardRange.new(test_component_id: @testcomponent.id, gender: standard.gender, range_value: standard.range_value, age_limit: standard.age_limit, age_male_range_value: standard.age_male_range_value, age_female_range_value: standard.age_female_range_value, enterprise_id: @enterprise.id)
                    @standardRange.save!
                  end
                end
              end
            end
          end
        end
        render js: "window.location='#{staff_enterprises_path}'"
      else
        redirect_to new_staff_enterprise_path, notice: 'Sorry! Problem creating the Enterprise'
      end
    end
  end

  def lab_test_dump
    enterprise_id = params[:id]
    enterprise = Enterprise.find_by_enterprise_id('EK')
    @labtests = LabTest.where(enterprise_id: enterprise.id).order('id asc')
    @labtests.each do |test|
      @labtest = LabTest.new(name: test.name, info: test.info, enterprise_id: enterprise_id)
      if @labtest.save!
        @testcomponents = TestComponent.where(lab_test_id: test.id).order('id asc')
        @testcomponents.each do |components|
          @testcomponent = TestComponent.new(name: components.name, units: components.units, lab_test_id: @labtest.id, info: components.info, enterprise_id: enterprise_id)
          if @testcomponent.save!
            @standardRanges = StandardRange.where(test_component_id: components.id).order('id asc')
            @standardRanges.each do |standard|
              @standardRange = StandardRange.new(test_component_id: @testcomponent.id, gender: standard.gender, range_value: standard.range_value, age_limit: standard.age_limit, age_male_range_value: standard.age_male_range_value, age_female_range_value: standard.age_female_range_value, enterprise_id: enterprise_id)
              @standardRange.save!
            end
          end
        end
      end
    end
    render json: {message:"Success"}
  end

  def update
    @enterprise = Enterprise.find(params[:id])
    @enterprise.update enterprise_params
    respond_to do |format|
      format.html { render "show", :layout => !request.xhr?, :locals => {:enterprise => @enterprise} }
    end
  end

  def enterprises_active
    @enterprises_active = true
  end

  private
  def enterprise_params
    params.require(:enterprise).permit(:enterprise_id, :service_type, :name,:telephone,:offline_contact, staff_attributes: [:name, :id, :email],addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code])
  end

end
