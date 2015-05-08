class Customers::DashboardController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path

  def show
    customer = current_online_customer    
    @diabetic_score=customer.diabetic_score
    @hypertension_score=customer.hypertension_score(1).round(3)
    @hypertension_percentage=(@hypertension_score*100).round
    @medical_conditions=MedicalCondition.all
  end

  def inbox
    render partial: '/customers/dashboard/inbox'
  end

  def appointments
    render partial: '/customers/dashboard/appointments'
  end

  def share_with_doctor
    render partial: '/customers/dashboard/share_with_doctor'
  end

  def send_to_doctor
    doctor_name = params['doctor_name']
    doctor_mobile_number = params['doctor_mobile_number']
    doctor_email = params['doctor_email']
    customer_id = current_online_customer.id
    customer_name = current_online_customer.first_name
    inserted_row_id = DoctorOpinion.create(customer_id: customer_id,
                                           doctor_name: doctor_name,
                                           doctor_mobile_number: doctor_mobile_number,
                                           doctor_email: doctor_email)
    @resource = DoctorOpinion.find_by(id: inserted_row_id.id)
    respond_with_otp @resource, customer_name, inserted_row_id.id
    redirect_to customers_dashboard_path
  end

  def respond_with_otp(resource, customer_name, inserted_row_id, opts = {})
    otp=resource.otp_code.to_s()
    request_to_doctor = "EKINCARE: Dear " + resource[:doctor_name] + ", your opinion is important to " + customer_name + ", please follow the link for your valuable suggestions: "
    request_link = request.protocol + request.host_with_port + "/doctors_signin?id=" + inserted_row_id.to_s() + "%26otp=" + otp
    Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource[:doctor_mobile_number] +'&sender=EKCARE&message=' + request_to_doctor + request_link)))
  end

end
