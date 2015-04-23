class Staff::EnterpriseLoginController < StaffController
  before_action :staff_authenticated, :dashboard_active
  layout 'staff'

  def show
    @current_staff = current_staff
    @appointment_provider_list= AppointmentProvider.joins("inner join appointments on appointments.id = appointment_providers.appointment_id
                                where appointment_date >=current_date and provider_id in (select id from providers where enterprise_id = #{current_staff.admin_id})")
    if((@appointment_provider_list.empty?)==false)
      @aps=Array.new
      @appointment_provider_list.each do |i|        
        @aps.append(i.appointment_id)
      end
      @appointment_list=Appointment.find(@aps)
    end
  end

  protected
  def dashboard_active
    @dashboard_active = true
  end
end
