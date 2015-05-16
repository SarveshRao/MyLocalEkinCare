class Staff::EnterpriseStatisticsDataController < ApplicationController
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
    under_weights=Array.new
    obese=Array.new
    overweight=Array.new
    healthy=Array.new
    @customers_list.each do |customer|
      case customer.obesity_overweight_checkup
        when 1;under_weights.push(customer)
        when 2;healthy.push(customer)
        when 3;overweight.push(customer)
        when 4;obese.push(customer)
      end
    end
    @healthy_customer_count=healthy.count()
    @overweight_customer_count=overweight.count()
    @obesity_customer_count=obese.count()

    render json: {healthy_customers:@healthy_customer_count,overweight_customers:@overweight_customer_count,obesity_customers:@obesity_customer_count}
  end
end
