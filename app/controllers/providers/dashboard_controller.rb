class Providers::DashboardController < ProvidersController
  before_action :provider_authenticated, :dashboard_active
  layout 'providers'

  def show
    @appointments = Appointment.all
    @customers = Customer.all
    @current_provider = current_provider
    # @appointment = current_provider.appointment_provider.appointment
  end

  protected
  def dashboard_active
    @dashboard_active = true
  end
end
