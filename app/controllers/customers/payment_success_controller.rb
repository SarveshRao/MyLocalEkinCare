class Customers::PaymentSuccessController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Packages', :customers_packages_path
  add_breadcrumb 'Payment Success'

  def index
    @customer_packages_page = true
    @key = params[:key]
    @txnid = params[:txnid]
    @amount = params[:amount]
    @status = params[:status]
    @mihpayid = params[:mihpayid]
    @mode = params[:mode]
    if @mode == "CC"
      @mode = "Credit Card"
    elsif @mode == "DC"
      @mode = "Debit Card"
    end
    if params[:discount]
      @discount = params[:discount]
    else
      @discount = ""
    end
    @hash = params[:hash]
    @error = params[:error_Message]
    @pg_type = params[:PG_TYPE]
    @bank_ref_num = params[:bank_ref_num]
    @unmappedstatus = params[:unmappedstatus]
    if params[:payuMoneyId].nil?
      @payu_id = params[:payuMoneyId]
    else
      @payu_id = ""
    end
    @name = params[:firstname]
    @reduced_amount = @amount.to_f - @discount.to_f

    @customer = current_online_customer
    if @name.nil?
      @name = @customer.first_name
    end
    @package = PackageDetail.find_by_txnid(@txnid)
    @package_detail = ProviderTest.find(@package.package_id)
    @address = Address.find_by("addressee_id= #{@package.customer_id}::text and addressee_type='Customer'")

    line1 =  @address.line1 ? @address.line1 : " "
    line2 =  @address.line2 ? @address.line2 : " "
    city =  @address.city ? @address.city : " "
    state =  @address.state ? @address.state : " "
    country =  @address.country ? @address.country : " "
    customer_address = line1 + ", " + line2 + ", " + city + ", " + state + ", " + country
    @payment_details = PaymentDetail.new(txnid: @txnid, status: @status, amount: @amount, mihpayid: @mihpayid, mode: @mode, discount: @discount,
                                         checksum: @hash, error: @error, pg_type: @pg_type, bank_ref_num: @bank_ref_num, unmappedstatus: @unmappedstatus, payumoney_id: @payu_id, package_id: @package.id)

    if @payment_details.save!
      @coupon=Coupon.all.first
      @customer_coupon=CustomerCoupon.where("customer_id = ? AND coupon_id = ?",@customer.id, @coupon.id).first
      if @customer_coupon
        if((@customer_coupon.is_coupon_applied?) and (@customer_coupon.is_coupon_used? ==false))
          CustomerCoupon.update(@customer_coupon.id,txn_id:@txnid)
          usage_count=@coupon.no_of_users_used rescue 0
          if usage_count.nil?
            usage_count = 0
          end
          Coupon.update(@coupon.id,no_of_users_used:usage_count+1)
        end
      end
      unless @package.appointment_body.nil?
        appointment_body = @package.appointment_body.to_s
        appointment_body = appointment_body[0,appointment_body.length-7]
        Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @customer.mobile_number() +'&sender=EKCARE&message=CONFIRMATION: Dear '+ @customer.first_name() +', your EKINCARE body check up is SCHEDULED for '+ appointment_body.to_s+' at your home. Call 8886783546 for queries. Please carry a copy of valid ID proof for the appointment')))
      end

      unless @package.appointment_dental.nil?
        appointment_dental = @package.appointment_dental.to_s
        appointment_dental = appointment_dental[0, appointment_dental.length-7]
        @dental_address = Address.find_by("addressee_id= #{@package.provider_dental}::text and addressee_type = 'Provider'")
        line1 =  @dental_address.line1 ? @dental_address.line1 : " "
        line2 =  @dental_address.line2 ? @dental_address.line2 : " "
        city =  @dental_address.city ? @dental_address.city : " "
        state =  @dental_address.state ? @dental_address.state : " "
        country =  @dental_address.country ? @dental_address.country : " "
        dental_address = line1 + ", " + line2 + ", " + city + ", " + state + ", " + country
        @provider_dental = Enterprise.joins("inner join providers on enterprises.id = providers.enterprise_id").where("providers.id=?",@package.provider_dental).first
        provider_dental = @provider_dental.name
        Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @customer.mobile_number() +'&sender=EKCARE&message=CONFIRMATION: Dear '+ @customer.first_name() +', your EKINCARE dental check up is SCHEDULED for '+ appointment_dental.to_s+' at '+provider_dental+'. Call 8886783546 for queries. Please carry a copy of valid ID proof for the appointment')))
      else
        provider_dental = ""
      end

      unless @package.appointment_vision.nil?
        appointment_vision = @package.appointment_vision.to_s
        appointment_vision = appointment_vision[0, appointment_vision.length-7]
        @vision_address = Address.find_by("addressee_id = #{@package.provider_vision}::text and addressee_type = 'Provider'")
        line1 =  @vision_address.line1 ? @vision_address.line1 : " "
        line2 =  @vision_address.line2 ? @vision_address.line2 : " "
        city =  @vision_address.city ? @vision_address.city : " "
        state =  @vision_address.state ? @vision_address.state : " "
        country =  @vision_address.country ? @vision_address.country : " "
        vision_address = line1 + ", " + line2 + ", " + city + ", " + state + ", " + country
        @provider_vision = Enterprise.joins("inner join providers on enterprises.id = providers.enterprise_id").where("providers.id=?",@package.provider_vision).first
        provider_vision = @provider_vision.name.to_s
        Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @customer.mobile_number() +'&sender=EKCARE&message=CONFIRMATION: Dear '+ @customer.first_name() +', your EKINCARE vision check up is SCHEDULED for '+ appointment_vision.to_s+' at '+provider_vision+'. Call 8886783546 for queries. Please carry a copy of valid ID proof for the appointment')))
      else
        provider_vision = ""
      end

      if @package.appointment_dental.nil?
        @provider_dental = ""
      end

      if @package.appointment_vision.nil?
        @provider_vision = ""
      end

      url = request.protocol + request.host_with_port
      Notification.customer_payment_success(@name, @payu_id, @amount, @discount, @txnid, @mode,@customer.email, @reduced_amount, @customer.customer_id, url).deliver!
      Notification.customer_appointment_success(appointment_body, appointment_dental, appointment_vision, @name, @package_detail.name, @package_detail.mrp, @amount, @package_detail.discount, customer_address, @customer.email, dental_address, vision_address, provider_dental, provider_vision, url).deliver!
    end
  end
end