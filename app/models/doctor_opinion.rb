class DoctorOpinion < ActiveRecord::Base

  has_one_time_password

  def need_two_factor_authentication?(request)
    not otp_secret_key.nil?
  end

end