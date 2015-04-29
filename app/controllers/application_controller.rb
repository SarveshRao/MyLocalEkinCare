class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #protect_from_forgery with: :exception
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    customers_dashboard_path
  end

  def after_sign_out_path_for(resource)
    new_online_customer_session_path
  end

  def layout_by_resource
    if controller_name == 'home'
      "home"
    end
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  {|u| u.permit(:first_name, :last_name, :gender, :email, :date_of_birth, :password, :confirm_password, :mobile_number)}
  end
end

