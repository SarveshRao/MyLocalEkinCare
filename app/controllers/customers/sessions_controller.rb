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
    self.resource = Customer.find_by(mobile_number: params[:online_customer][:mobile_number])
    if self.resource.authenticate_otp(params[:online_customer][:otp], drift: 900) == true
      sign_in(resource_name, self.resource)
      redirect_to after_sign_in_path_for(self.resource)
    else
      set_flash_message(:error, :wrong_otp) if is_flashing_format?
      redirect_to new_online_customer_session_path
    end
  end

end
