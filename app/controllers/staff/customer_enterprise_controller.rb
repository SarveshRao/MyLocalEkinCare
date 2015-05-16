class Staff::CustomerEnterpriseController < StaffController
  before_action :staff_authenticated, :dashboard_active
  layout 'staff'
  add_breadcrumb 'Home', :staff_enterprise_login_path

  def index
    @current_staff = current_staff
    @customers_list=Array.new

    @appointment_customer_list= AppointmentProvider.joins("inner join appointments on appointments.id = appointment_providers.appointment_id
                                where provider_id in (select id from providers where enterprise_id = #{current_staff.admin_id})")
    if((@appointment_customer_list.empty?)==false)
      @aps=Array.new
      @appointment_customer_list.each do |i|
        @aps.append(i.appointment_id)
      end
      @appointment_customer=Appointment.find(@aps)
    end
    unless @appointment_customer.nil?
      @appointment_customer.each do |ap|
        unless(@customers_list.include?(ap.customer))
          @customers_list.append(ap.customer)
        end
      end
    end
    add_breadcrumb 'Customers', :staff_customer_enterprise_index_path
  end

  def show
    @customer = Customer.includes([:health_assessments]).find(params[:id])
    @appointment_customer_list= AppointmentProvider.joins("inner join appointments on appointments.id = appointment_providers.appointment_id
                                where provider_id in (select id from providers where enterprise_id = #{current_staff.admin_id})")
    if((@appointment_customer_list.empty?)==false)
      @aps=Array.new
      @appointment_customer_list.each do |i|
        @aps.append(i.appointment_id)
      end
      #@appointment_customer=Appointment.find(@aps)
      @health_assessments = @customer.health_assessments.where("id in (select appointmentee_id from Appointments where id in (?))", @aps)
    end
    add_breadcrumb 'Customers', :staff_customer_enterprise_index_path
    add_breadcrumb @customer.name
  end

  protected
  def dashboard_active
    @customer_active = true
  end
end
