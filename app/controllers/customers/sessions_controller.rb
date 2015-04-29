class Customers::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    if self.resource.confirmed?
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
    else
      set_flash_message(:error, :unconfirmed) if is_flashing_format?
      sign_out(resource_name)
      redirect_to new_online_customer_session_path
    end
  end
end
