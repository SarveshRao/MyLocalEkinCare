class Staff::PasswordResetController < ApplicationController

  def new
    @staff = Staff.new
  end

  def update

    @staff = Staff.where(email: params[:staff][:email]).where.not(admin_type: 'Provider').first
    if @staff

      @staff.password = SecureRandom.hex(4)
      @staff.save!
      Notification.staff_password_reset(@staff).deliver!
      redirect_to new_staff_session_path, notice: 'You will receive an email with new password in a few seconds.'
    else
      redirect_to new_staff_session_path, alert: 'Your email does not exist in our database'
    end
  end
end