class Customers::OtpController < ApplicationController

  def generate_otp
    @resource = Customer.find_by(mobile_number: params[:mobile_number])
    if @resource
      respond_with_otp @resource
    else
      render json: {statusCode: 404}
    end
  end

  def respond_with_otp(resource, opts = {})
    otp=resource.otp_code.to_s()
    Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ resource[:mobile_number] +'&sender=EKCARE&message=OTP: Dear '+ resource[:first_name] +', your eKincare otp is '+ otp +'. Call 8886783546 for questions.')))
    render json: {statusCode: 200}
  end

end