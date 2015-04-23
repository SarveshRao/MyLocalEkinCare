class Customers::RegistrationsController < Devise::RegistrationsController
 
  # GET /resource/sign_up
  def new
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
        if resource.save
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

          # need to assign coupon as per requirement
          coupon=Coupon.all.first

          unless(coupon.nil?)
            if(coupon.expires_on>Time.now)
              expire_date = coupon.expires_on.to_s
              coupon_sms = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource.mobile_number() +'&sender=EKCARE&message=Dear '+ resource.first_name() +', Avail Coupon Worth Rs '+ (coupon.price.to_s) +' on your purchase at eKincare.com. Call 8886783546 for queries. Coupon code: '+coupon.code+'. Valid till '+expire_date[0,10])))
              CustomerCoupon.create(customer_id:resource.id,coupon_id:coupon.id)
            end
          end



        else
          clean_up_passwords resource
          flash[:error] = "#{resource.errors.full_messages.join(',')}"
          respond_with resource, location: registration_path(resource_name)
          #   channel = params[:online_customer][:channel]
          #   if channel.present?
          #     case channel
          #       when 'ad1'
          #         # respond_with resource, location: after_sign_up_path_for(resource)
          #         redirect_to('/ad1')
          #         return
          #     end
          #   end
        end

        # respond_to do |format|
        #   format.html
        #   format.json {render json: {msg: 'Signed up successfully'}}
        # end
      end
    end
  end

  def after_sign_up_path_for(resource)
    channel = params[:online_customer][:channel]
    if channel.present?
      case channel
        when 'ad1'
          ad1_thankyou_path
      end
    else
      set_flash_message :notice, :confirmation if is_flashing_format?
      new_online_customer_registration_path
    end
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

  def success_msg
    render json: {msg: 'success'}, status: :ok
  end

  def failure_msg
    render json: {msg: 'error'}, status: :unprocessable_entity
  end
end
