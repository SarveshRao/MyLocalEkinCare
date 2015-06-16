class Customers::RegistrationsController < Devise::RegistrationsController
 
  # GET /resource/sign_up
  def new
    if request.referer and request.referer.index('?') != nil
      utm_source = CGI::parse(request.referer[request.referer.index('?')+1,request.referer.length])['utm_source'].to_s
      session[:utm_source] = nil
      session[:utm_source] = utm_source[2..utm_source.length-3]
    end
    provider_data = session["devise.facebook_data"] || session["devise.google_oauth2_data"]

    new_customer_data =
        if provider_data
          {
              'email' => provider_data['info']['email'],
              'first_name' => provider_data['info']['first_name'],
              'last_name' => provider_data['info']['last_name'],
              'gender' => provider_data['extra']['raw_info']['gender'],
          }
        else
          {}
        end

    build_resource(new_customer_data)
    respond_with self.resource
  end

  # POST /resource
  def create
    if params[:format] == 'json'
      puts "\n\n*****************from json block*************************\n\n"
      accept_signup_with_xhr
    else
      build_resource(sign_up_params)

      provider_data = session["devise.facebook_data"] || session["devise.google_oauth2_data"]

      if provider_data
        puts "\n\n******************from provider data*******************\n\n"
        existing_identity = Identity.find_by_uid(provider_data['uid'])

        if existing_identity
          unless resource.identities.include?(existing_identity)
            resource.identities << existing_identity
          end
        else
          resource.identities.build(
              {
                  'uid' => provider_data['uid'],
                  'provider' => provider_data['provider']
              }
          )
        end
        if !resource.valid?
          flash[:error] = "#{resource.errors.full_messages.join(',')}"
          respond_with resource, location: registration_path(resource_name)
        end
      else
        puts "\n\n************************from else provider data************************\n\n"
        resource.confirmed_at = Time.now()
        resource.is_mobile_number_verified = 0
        @current_customer = Customer.find_by_mobile_number(params[:online_customer][:mobile_number])
        if !@current_customer.nil? and @current_customer.is_mobile_number_verified == 0
          respond_with @current_customer, location: after_mobile_confirmation_path_for(@current_customer)
        else
          if resource.save
            cookies[:mobile_number] = params[:online_customer][:mobile_number]
            if session[:utm_source]
              # Adding the post call after successful registration ends here
              raw_xml = "<Leads><row no='1'><FL val='Phone'>" + resource.customer_id + "</FL><FL val='Lead Source'>" + session[:utm_source].to_s + "</FL><FL val='Last Name'>-</FL></row></Leads>"
              encoded_xml = CGI::escape(raw_xml)
              uri = URI.parse('https://crm.zoho.com/crm/private/json/Leads/insertRecords?authtoken=460110734aed45ea412ab6637dd4cbf8&xmlData='+encoded_xml)
              http = Net::HTTP.new(uri.host, uri.port)
              http.use_ssl = true
              post_request = Net::HTTP::Post.new(uri, {'Content-Type' =>'text/xml'})
              response = http.request(post_request)
              session[:utm_source] = nil
              # Adding the post call after successful registration ends here
            end
            yield resource if block_given?
            if resource.active_for_authentication?
              #sign_up(resource_name, resource)
              respond_with resource, location: after_sign_up_path_for(resource)
            else
              set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
              expire_data_after_sign_in!
              respond_with resource, location: after_inactive_sign_up_path_for(resource)
            end
            CustomerVitals.create(customer_id: resource.id)
            # "Sending SMS to mobile"
            result = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource.mobile_number() +'&sender=EKCARE&message=Dear '+ resource.first_name() +', DOWNLOAD FREE EKINCARE APP, to digitize your physical medical records. Click http://bit.ly/eKgoogle for ANDROID or click http://bit.ly/eKapple for Apple iPhone')))
            ekincare_coupon=CouponSource.find_by_name('ekincare')
            ek_coupon=ekincare_coupon.coupons.first
            if(ek_coupon)
              if ek_coupon.is_valid_coupon?
                expire_date = ek_coupon.expires_on.to_s
                expire_date = expire_date[8..9]+"-"+expire_date[5..6]+"-"+expire_date[0..3]
                coupon_sms = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource.mobile_number() +'&sender=EKCARE&message=Dear '+ resource.first_name() +', Avail coupon worth Rs. '+ (ek_coupon.price.to_s) +' on your next health check at eKincare.com. Call 888-678-3546 for details. Coupon code '+ek_coupon.code+'. Valid till '+expire_date)))
                CustomerCoupon.create(customer_id:resource.id,coupon_id:ek_coupon.id)
              end
            end
            coupon=cookies[:coupon]
            source=cookies[:source]
            cookies.delete(:coupon)
            cookies.delete(:source)
            if(coupon and source)
              assign_coupon(resource.id,coupon,source)
            end
            generate_otp resource
          else
            clean_up_passwords resource
            flash[:error] = "#{resource.errors.full_messages.join(',')}"
            respond_with resource, location: registration_path(resource_name)
          end
        end
      end
    end
  end

  def generate_otp resource
    otp=resource.otp_code.to_s()
    Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource[:mobile_number] +'&sender=EKCARE&message=OTP: Dear '+ resource[:first_name] +', your eKincare otp is '+ otp +'. Call 8886783546 for questions.')))
  end

  def after_sign_up_path_for(resource)
    channel = params[:online_customer][:channel]
    if channel.present?
      case channel
        when 'ad1'
          ad1_thankyou_path
      end
    else
      set_flash_message :notice, :otp_confirmation if is_flashing_format?
      send_registration_otp_path
    end
  end

  def after_mobile_confirmation_path_for(resource)
    generate_otp resource
    set_flash_message :notice, :mobile_otp_confirmation if is_flashing_format?
    send_registration_otp_path
  end

  def accept_signup_with_xhr
    # Check for duplicate email/mobile number for mobile api
    build_resource(sign_up_params)
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        success_msg
      else
        expire_data_after_sign_in!
        failure_msg
      end
      CustomerVitals.create(customer_id: resource.id)
    else
      clean_up_passwords resource
      failure_msg
    end
  end

  def accept_signup_with_xhr_new
    build_resource(sign_up_params)
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        success_msg_new resource
      else
        expire_data_after_sign_in!
        failure_msg
      end
      CustomerVitals.create(customer_id: resource.id)
    else
      clean_up_passwords resource
      failure_msg
    end
  end

  def success_msg_new resource
    @mobile_number = resource.mobile_number
    @customer = Customer.find_by_mobile_number(@mobile_number)
    render json: @customer.to_json(:include => [:customer_vitals, :family_medical_histories])
  end

  def success_msg
    render json: {msg: 'success'}, status: :ok
  end

  def failure_msg
    render json: {msg: 'error'}, status: :unprocessable_entity
  end

  def assign_coupon customer_id,coupon_code,source
    begin
      coupon_source=CouponSource.find_by_name(source)
      if(coupon_source.is_valid_coupon?(coupon_code))
        coupon=Coupon.find_by_code(coupon_code)
        CustomerCoupon.create(customer_id:customer_id,coupon_id:coupon.id)
        return true
      end
    rescue
      return false
    end
    return false
  end
  def register
    if params[:format] == 'json'
      puts "\n\n*****************from json block*************************\n\n"
      accept_signup_with_xhr_new
    end
  end

  def register_family_member_post
    # Check for validations
    @customer = Customer.find_by_mobile_number(params[:mobile_number])
    if @customer.nil?
      temporaryPassword = SecureRandom.hex(4)
      # Save the data - make confirmed_at filled to current datetime
      inserted_row = Customer.create(first_name: params[:first_name],
                                     last_name: params[:last_name],
                                     email: params[:email],
                                     mobile_number: params[:mobile_number],
                                     date_of_birth: params[:date_of_birth],
                                     gender: params[:gender],
                                     password: temporaryPassword,
                                     guardian_id: params[:guardian_id],# this is current customer id
                                     confirmed_at: DateTime.now,
                                     is_mobile_number_verified: 0
      # Need to add relation
      )

      # send email to reset the family member password
      # inserted_row.invite!

      CustomerVitals.create(customer_id: inserted_row.id)
      # "Sending SMS to mobile"
      # result = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ inserted_row.mobile_number() +'&sender=EKCARE&message=Dear '+ inserted_row.first_name() +', DOWNLOAD FREE EKINCARE APP, to digitize your physical medical records. Click http://bit.ly/eKgoogle for ANDROID or click http://bit.ly/eKapple for Apple iPhone')))
      # Check for coupon code....required/not
      #   ekincare_coupon=CouponSource.find_by_name('ekincare')
      #   ek_coupon=ekincare_coupon.coupons.first
      #   expire_date = ek_coupon.expires_on.to_s
      #   expire_date = expire_date[8..9]+"-"+expire_date[5..6]+"-"+expire_date[0..3]
      #   coupon_sms = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ inserted_row.mobile_number() +'&sender=EKCARE&message=Dear '+ inserted_row.first_name() +', Avail coupon worth Rs. '+ (ek_coupon.price.to_s) +' on your next health check at eKincare.com. Call 888-678-3546 for details. Coupon code '+ek_coupon.code+'. Valid till '+expire_date)))
      #   CustomerCoupon.create(customer_id:inserted_row.id,coupon_id:ek_coupon.id)
      sign_in(inserted_row)
      redirect_to after_sign_in_path_for(inserted_row)
    else
      render :status => 409, :json => { :message => "Mobile number has already taken" }
    end

  end

  def customer_params
    params.require(:online_customer).permit(:first_name, :last_name, :email, :date_of_birth, :daily_activity, :frequency_of_exercise,
                                     :gender, :martial_status, :language_spoken, :ethnicity, :smoke, :alcohol, :medical_insurance, :customer_type, :diet,
                                     :religious_affiliation, :mobile_number, :alternative_mobile_number, :number_of_children, :guardian_id,
                                     addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code],
                                     customer_vitals_attributes: [:weight, :feet, :inches, :blood_group_id, :waist])
  end

  def send_otp_on_registration
    render 'devise/registrations/registration_otp'
  end

  def resend_otp_on_registration
    resource = Customer.find_by_mobile_number(cookies[:mobile_number])
    generate_otp resource
    render 'devise/registrations/registration_otp'
  end

  def verify_otp_signin
    self.resource = Customer.find_by(mobile_number: params[:mobile_number])
    if self.resource.authenticate_otp(params[:online_customer][:otp], drift: 900) == true #making 15min as OTP validation for doctor
      self.resource.is_mobile_number_verified = 1
      self.resource.save
      session[:is_customer] = true
      sign_in(resource_name, self.resource)
      redirect_to after_sign_in_path_for(self.resource)
    else
      set_flash_message(:error, :wrong_otp) if is_flashing_format?
      redirect_to :back
    end
  end

  # Get call
  def register_family_member_get
    render 'devise/registrations/register_family_member'
  end

end
