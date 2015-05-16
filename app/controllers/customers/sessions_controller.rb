class Customers::SessionsController < Devise::SessionsController

  # Require our abstraction for encoding/deconding JWT.
  require 'auth_token'

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    session[:is_customer] = true
    self.resource = Customer.find_by(mobile_number: params[:online_customer][:mobile_number])
    if !self.resource.nil?
      if self.resource.authenticate_otp(params[:online_customer][:otp], drift: 900) == true
        session[:is_customer] = true
        sign_in(resource_name, self.resource)
        redirect_to after_sign_in_path_for(self.resource)
      else
        set_flash_message(:error, :wrong_otp) if is_flashing_format?
        redirect_to new_online_customer_session_path
      end
    else
      set_flash_message(:error, :wrong_mobile_number) if is_flashing_format?
      redirect_to new_online_customer_session_path
    end
  end

  # GET call
  def sign_in_doctor_get
    @customer_id = params[:customer_id]
    self.resource = DoctorOpinion.find_by(id: params[:customer_id])
    if !self.resource.nil?
      render 'customers/sessions/sign_in_doctor'
    else
      render 'customers/sessions/sign_in_doctor_get'
    end
  end

  # POST call
  def sign_in_doctor_post
    self.resource = DoctorOpinion.find_by(id: params[:customer_id])
    if self.resource.authenticate_otp(params[:doctor_opinion][:otp], drift: 172800) == true #making 48hrs as OTP validation for doctor
      session[:doctor_name] = self.resource.doctor_name
      session[:doctor_mobile_number] = self.resource.doctor_mobile_number
      session[:doctor_email] = self.resource.doctor_email
      self.resource = Customer.find_by(id: self.resource.customer_id)
      session[:is_customer] = false
      sign_in(resource_name, self.resource)
      redirect_to after_sign_in_path_for(self.resource)
    else
      set_flash_message(:error, :wrong_otp) if is_flashing_format?
      redirect_to :back
      # render 'customers/sessions/sign_in_doctor_get'
    end
  end

end
