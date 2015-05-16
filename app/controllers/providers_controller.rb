class ProvidersController < ApplicationController

  helper_method :current_provider
  #before_filter :provider_authenticated
  layout :layout_by_resource

  def layout_by_resource
    current_provider ? 'providers' : 'application'
  end

  def index


  end

  protected
  def provider_authenticated
    unless session[:provider_id]
      redirect_to new_providers_session_path
    end
  end

  def current_provider
    #return if controller_name = "home"
    if session[:provider_id]
      @current_provider ||= Provider.find(session[:provider_id])
    end
  end

  private
  def user_params
    params.require(:sessions).permit(:email) #, :password, :password_confirmation)
  end
end
