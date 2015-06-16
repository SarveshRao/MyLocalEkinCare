class Staff::CustomersController < StaffController
  before_action :staff_authenticated,:customer_active
  layout 'staff'
  layout :layout_by_resource

  add_breadcrumb 'Home', :staff_staff_charts_index_path

  def layout_by_resource
    action_name == 'dashboard' ? 'home' : 'staff'
  end

  def new
    @customer = Customer.new
    add_breadcrumb 'New Customer', :new_customer_path
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    #@customer.blood_group_id = params[:blood_group_id] if params[:blood_group_id]
    weight_id=VitalList.find_by_name('weight').id
    feet_id=VitalList.find_by_name('feet').id
    inches_id=VitalList.find_by_name('inches').id
    if params[:customer][:weight] || params[:customer][:feet] || params[:customer][:inches] || params[:blood_group_id]
      customer_vitals = CustomerVitals.find_by("customer_id='#{params[:id]}'")
      customer_vitals.update(customer_id: params[:id], weight: params[:customer][:weight],feet: params[:customer][:feet],inches: params[:customer][:inches],blood_group_id: params[:blood_group_id])
    end
    @customer.save
    unless @customer.sponsor.nil?
      @sponsor = Company.find(@customer.sponsor).name
    end

    render partial: 'show'
  end

  def show
    @customer = Customer.includes([:allergies, :immunizations, :health_assessments, :customer_allergies, :customer_immunizations, :medications, :family_medical_histories]).find(params[:id])
    @allergies = @customer.allergies
    @immunizations = @customer.immunizations
    @health_assessments = @customer.health_assessments
    @health_assessments.each do |assessment|
      assessment.class_eval do
        attr_accessor :enterprise_name
      end
      if assessment.enterprise_id
        @enterprise = Enterprise.find(assessment.enterprise_id)
        assessment.enterprise_name = @enterprise.name
      end
    end
    @medications = @customer.medications
    @family_medical_histories = @customer.family_medical_histories
    @medical_conditions = MedicalCondition.all
    @appointments = ((@customer.appointments + @health_assessments.collect(&:appointments)).flatten.sort_by{ |appointment| appointment.id }).reverse
    @promo_codes=@customer.promo_codes
    @health_assessment_promo_codes=Array.new
    @promo_codes.each do |promo_code|
      @health_assessment_promo_codes.concat(promo_code.health_assessment_promo_codes)
    end
    @health_assessment_promo_codes.flatten
    unless @customer.sponsor.nil?
      @sponsor = Company.find(@customer.sponsor).name
    end
    add_breadcrumb 'Customers', :customers_path
    add_breadcrumb @customer.name
  end

  def create
    email =  params[:customer][email]
    is_email_exist = Customer.find_by_email(email)
    puts "email :"+is_email_exist.to_s
    if is_email_exist==''
      @new_customer = Customer.create!(customer_params) do |customer|
        customer.password = SecureRandom.hex
        # customer.unconfirmed_email = nil
        customer.confirmation_token = nil
        customer.status = 'thank_you_page'
        customer.confirmed_at = Time.now.utc
      end
      @new_customer.invite!

      #customer_vitals has to e replaced
      CustomerVitals.create(customer_id: @new_customer.id)
      Vital.create(customer_id: @new_customer.id)
      Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @new_customer.mobile_number() +'&sender=EKCARE&message=Dear '+ @new_customer.first_name() +', DOWNLOAD FREE EKINCARE APP, to digitize your physical medical records. Click http://bit.ly/eKgoogle for ANDROID or click http://bit.ly/eKapple for Apple iPhone')))

      if params[:customer][:sponsor]==""
        ekincare_coupon=CouponSource.find_by_name('ekincare')
        ek_coupon=ekincare_coupon.coupons.first

        if(ek_coupon)
          if ek_coupon.is_valid_coupon?
            expire_date = ek_coupon.expires_on.to_s
            expire_date = expire_date[8..9]+"-"+expire_date[5..6]+"-"+expire_date[0..3]
            coupon_sms = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @new_customer.mobile_number() +'&sender=EKCARE&message=Dear '+ @new_customer.first_name() +', Avail coupon worth Rs. '+ (ek_coupon.price.to_s) +' on your next health check at eKincare.com. Call 888-678-3546 for details. Coupon code '+ek_coupon.code+'. Valid till '+expire_date)))
            CustomerCoupon.create(customer_id:@new_customer.id,coupon_id:ek_coupon.id)
          end
        end
      end
      redirect_to customer_path(@new_customer)
    else
      # set_flash_message(:error, :duplicate_email) if is_flashing_format?
      flash[:error] = "Email has already been taken"
      redirect_to new_customer_path
    end
  end

  def index
    @customers = Customer.all

    add_breadcrumb 'Customers'
  end

  def dashboard
  end

  protected
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :date_of_birth, :daily_activity, :frequency_of_exercise, :sponsor,
                                     :gender, :martial_status, :language_spoken, :ethnicity, :smoke, :alcohol, :medical_insurance, :customer_type, :diet,
                                     :religious_affiliation, :mobile_number, :alternative_mobile_number, :number_of_children,
                                     addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code],
                                     customer_vitals_attributes: [:weight, :feet, :inches, :blood_group_id])
  end

  def customer_active
    @customer_active = true
  end
end
