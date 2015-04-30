class HomeController < ApplicationController
  def index
    if online_customer_signed_in?
      redirect_to customers_dashboard_path
    end
    @customer = Customer.new
    @packages = ProviderTest.joins("inner join enterprises on enterprises.id = provider_tests.provider_id where enterprise_id='EK' ")
  end

  def provider_address
    given_pin_code=params[:pin_code]
    @address = Address.find_by_zip_code(given_pin_code)
    locations=Array.new
    if @address
      @location=[@address.latitude,@address.longitude,@address.city]
      @address.venus1(10).each do |address|
        loc=Array.new
        unless(address.nil?)
          loc.push(address.latitude)
          loc.push(address.longitude)
          place=address.details rescue '-'
          loc.push(place)
          locations.push(loc)
        end
      end
    end
    respond_to do |format|
      format.json {render :json => {location:@location, locations: locations,:status => 200 }}
    end
  end

  def send_sms
    mobile_number=params[:mobile_number]

    unless(mobile_number.nil?)
      result = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ mobile_number +'&sender=EKCARE&message=Hi , DOWNLOAD FREE EKINCARE APP, to digitize your physical medical records. Click http://bit.ly/eKgoogle for ANDROID or click http://bit.ly/eKapple for Apple iPhone')))
      render json: {msg: 'success'}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end

  end

end