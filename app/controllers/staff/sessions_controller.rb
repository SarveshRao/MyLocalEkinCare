class Staff::SessionsController < StaffController
  skip_before_filter :staff_authenticated, only: [:new, :create]

  def new
    redirect_to staff_staff_charts_index_path if current_staff
  end

  def create
    @staff = Staff.authenticate(params[:staff][:email].downcase, params[:staff][:password])

    if @staff

      session[:staff_id] = @staff.id
      session[:login_type] = @staff.admin_type
      if @staff.admin_type == 'Enterprise'
        redirect_to staff_enterprise_login_path, notice: 'You have been logged in successfully'
      elsif @staff.admin_type == 'Company'
        redirect_to staff_company_login_path, notice: 'You have been logged in successfully'
      else
        redirect_to customers_path, notice: 'You have been logged in successfully'
      end
    else
      redirect_to new_staff_session_path, alert: 'Wrong email or password'
    end
  end

  def destroy
    session[:staff_id] = nil
    session[:login_type] = nil
    redirect_to new_staff_session_path, notice: 'You have been Signed out successfully'
  end
end
