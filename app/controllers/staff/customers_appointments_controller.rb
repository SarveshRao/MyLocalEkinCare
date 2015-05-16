class Staff::CustomersAppointmentsController < StaffController
  def create
    assessment_id = params[:appointment][:health_assessment_id]
    provider_id = params[:appointment][:appointment_provider][:provider_id] if params[:appointment][:appointment_provider].present?

    @customer = Customer.find(params[:customer_id])

    customer_address = params[:customer_address] == 'true' ? true : false
    carrier_obj = HealthAssessment.find(assessment_id.to_i)
    @appointment = carrier_obj.appointments.build(
        appointment_date: params[:appointment][:appointment_date], time: params[:appointment][:time],
        description: params[:appointment][:description],
        customer_address: customer_address)

    if !customer_address
      @appointment_provider = @appointment.build_appointment_provider(provider_id: provider_id.to_i, appointment: @appointment)
    end
    if(validate_health_assessment(carrier_obj.id))
      if @appointment.save
        render partial: 'new_appointment', html_safe: true
      end
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    customer_address = params[:customer_address]
    health_assessment_id = params[:appointment][:health_assessment_id]
    provider_id = params[:appointment][:appointment_provider][:provider_id] if params[:appointment][:appointment_provider].present?

    @appointment.appointment_date = params[:appointment][:appointment_date]
    @appointment.time = params[:appointment][:time]
    @appointment.description = params[:appointment][:description]
    @appointment.customer_address = customer_address

    @appointment_provider = AppointmentProvider.where(provider_id: provider_id, appointment_id: @appointment.id).first
    if @appointment_provider
      @appointment_provider.provider_id = provider_id
      @appointment_provider.save
    else
      @appointment.create_appointment_provider(provider_id: provider_id.to_i, appointment_id: @appointment.id)
    end


    #@appointment.update(appointment_params) do |appointment|
    #  if customer_address == 'true'
    #    appointment.customer_address = true
    #  else
    #    appointment.customer_address = false
    #    @appointment_provider = AppointmentProvider.find_or_create_by(appointment_id: @appointment.id)
    #    @appointment_provider.provider_id = provider_id
    #    @appointment_provider.save
    #  end
    #end
    if @appointment.save!
      render partial: 'updated_appointment'
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def destroy
    appointment = Appointment.find(params[:id])
    appointment_date = appointment.appointment_date
    assessment = HealthAssessment.find(appointment.appointmentee_id)
    customer = Customer.find(assessment.customer_id)
    Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ customer.mobile_number() +'&sender=EKCARE&message=CANCELLATION: Dear '+ customer.first_name() +', your EKINCARE '+ assessment.assessment_type.to_s() +' check up (APPT ID: '+ assessment.health_assessment_id.to_s() +'), is cancelled for '+ appointment.appointment_date.to_s() +' at '+ (appointment.appointment_provider ? appointment.appointment_provider.provider.addresses.first.details() : 'Home') +'. Call 8886783546 for questions.')))
    if appointment.destroy
      render json: {msg: 'success'}, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  protected
  def appointment_params
    params.require(:appointment).permit(:appointment_type, :appointment_date, :time, :description, :customer_address, appointment_provider_attributes: [:provider_id])
  end

  def validate_health_assessment id
    if(Appointment.find_by_appointmentee_id(id).nil?)
      return true
    end
    return false
  end
end
