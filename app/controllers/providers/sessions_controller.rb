class Providers::SessionsController < ProvidersController
  #skip_before_filter :provider_authenticated, only: [:new, :create]

  def new
    redirect_to providers_dashboard_path if current_provider
  end

  def create
    @provider = Provider.authenticate(params[:provider][:email].downcase)

    if @provider
      session[:provider_id] = @provider.id
      redirect_to providers_dashboard_path, notice: 'You have been logged in successfully'
    else
      redirect_to new_providers_session_path, alert: 'Wrong email or password'
    end
  end

  def destroy
    session[:provider_id] = nil
    redirect_to new_providers_session_path, notice: 'You have been Signed out successfully'
  end
end
