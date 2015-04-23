class StaffController < ApplicationController
  helper_method :current_staff
  before_filter :staff_authenticated
  layout :layout_by_resource

  def layout_by_resource
    current_staff ? 'staff' : 'application'
  end

  protected
  def staff_authenticated
    unless session[:staff_id]
      redirect_to new_staff_session_path
    end
  end

  def current_staff
    #return if controller_name = "home"
    if session[:staff_id]
      @current_staff ||= Staff.find(session[:staff_id])
    end
  end

  private
  def user_params
    params.require(:sessions).permit(:email, :password, :password_confirmation)
  end
end
