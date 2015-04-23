class Staff::DashboardController < StaffController
  before_action :staff_authenticated, :dashboard_active
  layout 'staff'

  def show
    @current_staff = current_staff
  end

  protected
  def dashboard_active
    @dashboard_active = true
  end
end
