class Notification < ActionMailer::Base
  include ApplicationHelper
  default from: '"eKincare Team" <info@ekincare.com>'

  def appointment_create_notifier(customer, activity, appointment)
    @customer = customer
    @activity = activity
    @appointment = appointment
    @assessment = appointment.appointmentee
    @appointment_date = formatted_date @appointment.date
    @appointment_time = full_time @appointment.date
    @title = "eKincare: #{ @assessment.assessment_type } checkup appointment"
    @provider_mail = @appointment.appointment_provider.provider.email rescue ''
    mail :to => @customer.email,
         :subject => @title,
         :cc => @provider_mail
  end

  def appointment_update_notifier(customer, activity, appointment)
    @customer = customer
    @activity = activity
    @appointment = appointment
    @assessment = appointment.appointmentee
    @appointment_date = formatted_date @appointment.date
    @appointment_time = full_time @appointment.date
    @title = "eKincare: Updated #{ @assessment.assessment_type.downcase } checkup appointment"
    @provider_mail = @appointment.appointment_provider.provider.email rescue ''
    mail :to => @customer.email,
         :subject => @title,
         :cc => @provider_mail
  end

  def recommendation_notifier(customer, activity, recommendation)
    @customer = customer
    @activity = activity
    @recommendation = recommendation
    mail :to => @customer.email,
         :subject => 'Recommendation Notice'
  end

  def assessment_notifier(customer, activity, assessment)
    @customer = customer
    @activity = activity
    @assessment = assessment
    mail :to => @customer.email,
         :subject => 'Assessment Notice'
  end

  def staff_account_notifier(staff)
    @staff = staff
    @path = new_staff_session_url
    mail :to => @staff.email,
         :subject => 'Account Password'
  end

  def staff_password_reset(staff)
    @staff = staff
    @path = new_staff_session_url
    mail :to => @staff.email,
         :subject => 'Account Password'
  end

  def customer_payment_success(name, payu_id, amount, discount, txnid, mode, email, reduced_amount, customer_id, url)
    @name = name
    @payu_id = payu_id
    @amount = amount
    @discount = discount
    @txnid = txnid
    @mode = mode
    @email = email
    @reduced_amount = reduced_amount
    @customer_id = customer_id
    @url = url
    if @url.index('localhost')
      mail :to => @email,
           :subject => 'Your transaction  with eKincare is successful(local)',
           :cc => 'rameshmanyam8@gmail.com'
    elsif @url.index('staging.ekincare.com')
      mail :to => @email,
           :subject => 'Your transaction  with eKincare is successful(staging)',
           :cc => 'customerexecutive@ekincare.com'
    else
      mail :to => @email,
           :subject => 'Your transaction  with eKincare is successful',
           :cc => 'customerexecutive@ekincare.com'
    end

  end

  def customer_appointment_success(appointment_body, appointment_dental, appointment_vision, customer_name, package_name, mrp, selling_price, discount, customer_address, email, dental_address, vision_address, provider_dental, provider_vision, url)
    @appointment_body = appointment_body
    @appointment_dental = appointment_dental
    @appointment_vision = appointment_vision
    @customer_name = customer_name
    @package_name = package_name
    @mrp = mrp
    @selling_price = selling_price
    @discount = discount
    @customer_address = customer_address
    @email = email
    @dental_address = dental_address
    @vision_address = vision_address
    @provider_dental = provider_dental
    @provider_vision = provider_vision
    @url = url
    if @url.index('localhost')
      mail :to => @email,
           :subject => 'Your appointments with eKincare is successful(local)',
           :cc => 'rameshmanyam8@gmail.com'
    elsif @url.index('staging.ekincare.com')
      mail :to => @email,
           :subject => 'Your appointments with eKincare is successful(staging)',
           :cc => 'customerexecutive@ekincare.com'
    else
      mail :to => @email,
           :subject => 'Your appointments with eKincare is successful',
           :cc => 'customerexecutive@ekincare.com'
    end
  end

  def customer_uploaded_documents(customer_id, url)
    @customer_id = customer_id
    @email = "reports@ekincare.com"
    @url = url
    if @url.index('localhost')
      mail :to => 'rameshmanyam8@gmail.com',
           :subject => 'Documents uploaded for customer ID (local): '+@customer_id
    elsif @url.index('staging.ekincare.com')
      mail :to => @email,
           :subject => 'Documents uploaded for customer ID (staging): '+@customer_id
    else
      mail :to => @email,
           :subject => 'Documents uploaded for customer ID: '+@customer_id
    end
  end

  def send_request_for_second_opinion(customer_first_name, customer_last_name, customer_mobile_number, doctor_name, to_email, request_link, ekincare_url)
    @customer_first_name = customer_first_name
    @customer_last_name = customer_last_name
    @customer_mobile_number = customer_mobile_number
    @doctor_name = doctor_name
    @email = to_email
    @url = request_link
    @ekincare_url = ekincare_url
    mail :to => @email,
         :subject => @customer_first_name + @customer_last_name + " is seeking your 2nd opinion"
  end

  def post_comments_second_opinion(customer_name, to_email, doctor_comment, notes, health_assessment, health_assessment_url, ekincare_url)
    @customer_name = customer_name
    @doctor_comment = doctor_comment
    @health_assessment = health_assessment
    @health_assessment_url = health_assessment_url
    @notes = notes
    @ekincare_url = ekincare_url
    @email = to_email
    mail :to => @email,
         :subject => @doctor_comment.doctor_name + " provided new comments"
  end

end
