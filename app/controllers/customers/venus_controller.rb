class Customers::VenusController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Packages', :customers_packages_path
  add_breadcrumb 'Checkout'

  def index
    @customer_packages_page = true
    @customer = session[:current_online_customer]
    @customer_id = @customer.id.to_s
    @address = Address.find_by("addressee_id= #{@customer_id}::text and addressee_type='Customer'")
    @package_info = ProviderTest.find_by("id=?",params[:package])
    unless @address.nil?
      if params[:distance]

        if @package_info.service_type[0] == "B"
          @location_body = @address.venus(params[:distance],"Body")
        elsif @package_info.service_type[0] == "D"
          if @package_info.name=="Apollo Smile Dental Package"
            @location_dental = @address.venus2(params[:distance],"Dental", "AD")
          else
            @location_dental = @address.venus(params[:distance],"Dental")
          end
        elsif @package_info.service_type[0] == "V"
          @location_vision = @address.venus(params[:distance],"Vision")
        end

        if @package_info.service_type[2] == "B"
          @location_body = @address.venus(params[:distance],"Body")
        elsif @package_info.service_type[2] == "D"
          if @package_info.name=="Apollo Smile Dental Package"
            @location_dental = @address.venus2(params[:distance],"Dental", "AD")
          else
            @location_dental = @address.venus(params[:distance],"Dental")
          end
        elsif @package_info.service_type[2] == "V"
          @location_vision = @address.venus(params[:distance],"Vision")
        end

        if @package_info.service_type[4] == "B"
          @location_body = @address.venus(params[:distance],"Body")
        elsif @package_info.service_type[4] == "D"
          if @package_info.name=="Apollo Smile Dental Package"
            @location_dental = @address.venus2(params[:distance],"Dental", "AD")
          else
            @location_dental = @address.venus(params[:distance],"Dental")
          end
        elsif @package_info.service_type[4] == "V"
          @location_vision = @address.venus(params[:distance],"Vision")
        end

        unless @location_dental.nil?
          if @location_dental.length < 1
            if @package_info.name=="Apollo Smile Dental Package"
              @location_dental = @address.venus2(6,"Dental", "AD")
            else
              @location_dental = @address.venus(6,"Dental")
            end
          end
        end
        unless @location_vision.nil?
          if @location_vision.length < 1
            @location_vision = @address.venus(6,"Vision")
          end
        end
        unless @location_dental.nil?
          if @location_dental.length < 1
            if @package_info.name=="Apollo Smile Dental Package"
              @location_dental = @address.venus2(10,"Dental", "AD")
            else
              @location_dental = @address.venus(10,"Dental")
            end
          end
        end
        unless @location_vision.nil?
          if @location_vision.length < 1
            @location_vision = @address.venus(10,"Vision")
          end
        end
      end
    end

    transID = Time.new.to_i
    @transID = "EKPUM"+@customer_id + transID.to_s
    path = request.protocol + request.host_with_port
    if path.index('localhost')
      @key = "JBZaLc"
      @salt = "GQs7yium"
      @url = "https://test.payu.in/_payment"
    else
      @key = ENV['EKINCARE_Payment_Key']
      @salt = ENV['EKINCARE_Payment_Salt']
      @url = ENV['EKINCARE_Payment_URL']
    end

    product_info = "eKincare"
    pipe ="|||||||||"
    @hash = Digest::SHA512.hexdigest(@key+"|"+@transID+"|"+@package_info.selling_price.to_s+"|"+product_info+"|"+@customer.first_name+"|"+@customer.email+"|||||||||||"+@salt)
  end

  def update
    @customer = session[:current_online_customer]
    @address = Address.find_by("addressee_id= #{@customer.id}::text and addressee_type='Customer'")
    address_attributes = params[:customer][:addresses_attributes][:"0"]
    if @address
      if @address.update(line1: address_attributes[:line1], line2: address_attributes[:line2], city: address_attributes[:city], state: address_attributes[:state], country: address_attributes[:country], zip_code: address_attributes[:zip_code])
        redirect_to customers_venus_path(:distance => 3, :package => params[:customer][:package]), notice: "address has been updated successfully!"
      else
        render text: 'error', status: :unprocessable_entity
      end
    else
      @address = Address.new(line1: address_attributes[:line1], line2: address_attributes[:line2], city: address_attributes[:city], state: address_attributes[:state], country: address_attributes[:country], zip_code: address_attributes[:zip_code], addressee_id: @customer.id, addressee_type: 'Customer')
      if @address.save!
        redirect_to customers_venus_path(:distance => 3, :package => params[:customer][:package]), notice: "address has been inserted successfully!"
      else
        render text: 'error', status: :unprocessable_entity
      end
    end
  end

  def apply_coupon_code
    @code=params[:code]
    @amount=params[:amount]
    @customer=session[:current_online_customer]
    @coupon=Coupon.where("lower(code) = ? ",@code.downcase).first
    @email = params[:email]
    @firstname = params[:firstname]
    @productinfo = params[:productinfo]
    @txnid = params[:txnid]
    @key = params[:key]
    @service_provider = params[:service_provider]

    path = request.protocol + request.host_with_port
    if path.index('localhost')
      @salt = "GQs7yium"
    else
      @salt = ENV['EKINCARE_Payment_Salt']
    end

    respond_to do |format|
      unless(@coupon.nil?)
        if @coupon.is_valid_coupon?
          @customer_coupon=CustomerCoupon.where("customer_id = ? AND coupon_id = ?",@customer.id, @coupon.id).first
          unless(@customer_coupon.nil? or @customer_coupon.is_coupon_used?)
            net_amount=get_net_amount(@customer_coupon,@amount,@coupon.price)
            @net_amount = '%.1f' % (net_amount.to_f)
            @net_amount1 = '%.2f' % (net_amount.to_f)
            @hash = @hash = Digest::SHA512.hexdigest(@key+"|"+@txnid+"|"+@net_amount.to_s+"|"+@productinfo+"|"+@firstname+"|"+@email+"|||||||||||"+@salt)
            format.json {render :json => { coupon_id: @customer_coupon.coupon_id,net_amount: @net_amount, net_amount1: @net_amount1, hash_value: @hash, coupon_code:@customer_coupon.id },:status => 200}
          else
            format.json {render json:{error:"coupon already used"}, status: 422}
          end
        else
          format.json {render json: {error:"invalid coupon"}, status: 422}
        end
      else
        format.json {render json: {error:"Coupon not yet started or expired"}, status: 422}
      end
    end
  end

  def get_net_amount customer_coupon,amount,coupon_price
    @net_amount=amount
    unless(customer_coupon.is_coupon_used?)
      CustomerCoupon.update(customer_coupon.id,is_used:true)
      if amount.to_i>coupon_price.to_i
        @net_amount=amount.to_i-coupon_price.to_i
      else
        @net_amount = 0
      end
    end
    return @net_amount
  end
end