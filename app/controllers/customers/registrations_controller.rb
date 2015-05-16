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
        # check if otp entered is valid/expired - if valid remove session data
        if params[:online_customer][:otp] == session[:otp] and session[:otp_expire] > Time.now()
          set_resource_data resource
          clear_session_data
          puts "\n\n************************from else provider data************************\n\n"
          if resource.save
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
            redirect_to after_sign_up_path_for resource
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
          else
            clean_up_passwords resource
            flash[:error] = "#{resource.errors.full_messages.join(',')}"
            respond_with resource, location: registration_path(resource_name)
          end
        else
          # say that otp is wrong or expired
          set_flash_message(:error, :wrong_otp) if is_flashing_format?
          render 'devise/registrations/registration_otp'
        end
      end
    end
  end

  def after_sign_up_path_for resource
    otp = resource.otp_code.to_s
    if resource.authenticate_otp(otp, drift: 900) == true
      session[:is_customer] = true
      sign_in(resource_name, self.resource)
      customers_dashboard_path
    end
    # set_flash_message :notice, :sign_in if is_flashing_format?
    # new_online_customer_session_path
  end

  def accept_signup_with_xhr
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
      CustomerVitals.create(customer_id: resource.id)
      yield resource if block_given?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        success_msg_new resource
      else
        expire_data_after_sign_in!
        failure_msg
      end
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

  def send_otp_on_registration
    if(session[:otp].nil?)
      session[:first_name] = params[:online_customer][:first_name]
      session[:last_name] = params[:online_customer][:last_name]
      session[:email] = params[:online_customer][:email]
      session[:date_of_birth] = params[:online_customer][:date_of_birth]
      session[:gender] = params[:online_customer][:gender]
      session[:mobile_number] = params[:online_customer][:mobile_number]
    end
    # generating temporary otp for registration
    @temp_customer = Customer.new
    @temp_customer.id = -1
    @temp_customer.otp_secret_key = ROTP::Base32.random_base32
    otp = @temp_customer.otp_code.to_s
    session[:otp] = otp
    session[:otp_expire] = Time.now() + 15.minutes
    Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ session[:mobile_number] +'&sender=EKCARE&message=OTP: Dear '+ session[:first_name] +', your eKincare otp is '+ otp +'. Call 8886783546 for questions.')))
    set_flash_message(:notice, :sms_sent) if is_flashing_format?
    render 'devise/registrations/registration_otp'
  end

  def clear_session_data
    session[:first_name] = nil
    session[:last_name] = nil
    session[:email] = nil
    session[:date_of_birth] = nil
    session[:gender] = nil
    session[:mobile_number] = nil
    session[:otp] = nil
  end

  def set_resource_data resource
    resource.first_name = session[:first_name]
    resource.last_name = session[:last_name]
    resource.email = session[:email]
    resource.date_of_birth = session[:date_of_birth]
    resource.gender = session[:gender]
    resource.mobile_number = session[:mobile_number]
  end

  def verify_duplicate_records
    record_duplicated = false
    errors_full_messages = []
    if Customer.find_by_mobile_number(params[:online_customer][:mobile_number]).nil?
      record_duplicated = true
      errors_full_messages.push(find_message(:wrong_mobile_number, {}))
    end
    if Customer.find_by_email(params[:online_customer][:email]).nil?
      record_duplicated = true
      errors_full_messages.push(find_message(:wrong_otp, {}))
    end
    record_duplicated
  end
end
