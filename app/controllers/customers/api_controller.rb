class Customers::ApiController < BaseApiController

  def document
    @ids = HealthAssessment.where(customer_id: params[:id]).pluck(:id)
    medical_records = MedicalRecord.where(record_id: params[:id], record_type: 'Customer')
    medical_records.concat(MedicalRecord.where(record_id: @ids, record_type: 'HealthAssessment'))
    render json: medical_records
  end

  def profile
    @customer = Customer.find_by_id(params[:id])
    render json: @customer.to_json(:include => [:customer_vitals, :family_medical_histories])
  end

  def login
    @username = params[:email]
    @username = @username.downcase
    @password = params[:password]
    @customer = Customer.find_by_email(@username)
    if @customer
      @isValid = @customer.valid_password?(@password)
    end
    if @isValid
      render json: @customer.to_json(:include => [:customer_vitals, :family_medical_histories])
    else
      render :status => 401, :json => { :error => "Invalid User" }
    end
  end

  def login_otp
    @mobile_number = params[:mobile_number]
    @customer = Customer.find_by_mobile_number(@mobile_number)
    if @customer
      # Add otp generation logic here
      @isValid = true
      @customer.otp = @customer.otp_code.to_s()
      @customer.otp_expire = Time.now() + 15.minutes
    end
    if @isValid
      Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ @customer.mobile_number+'&sender=EKCARE&message=OTP: Dear '+ @customer.first_name+', your eKincare otp is '+ @customer.otp+'. Call 8886783546 for questions.')))
      render json: @customer.to_json(:include => [:customer_vitals, :family_medical_histories], :methods => [:otp, :otp_expire])
    else
      render :status => 401, :json => { :error => "The mobile number you provided is not registered with ekincare" }
    end
  end

  def upload_documents
    @customer = Customer.find(params[:id])
    puts @customer.id
    params[:files].each do |file|
      @medical_record = @customer.medical_records.build(emr: file, date: params[:date], title: params[:name]? params[:name] : file.original_filename)
      if @medical_record.save!
        url = request.protocol + request.host_with_port
        Notification.customer_uploaded_documents(@customer.customer_id, url).deliver!
        render :status => 200, :json => { message:"Success", document: JSON.parse(@medical_record.to_json()) }
      end
    end
  end

  def update_customer
    @customer = Customer.find(params[:id])
    respond_to do |format|
      if @customer.update_attributes(customer_params)
        format.json {render :status => 200, :json => { :message => "Success" }}
      else
        format.json {render :status => 400, :json => { :error => "Customer profile not updated" }}
      end
    end
  end

  def getCustomers
    @customers_temp = Customer.search(params[:sSearch])
    @customer = @customers_temp.page((params[:iDisplayStart].to_i/params[:iDisplayLength].to_i) + 1).per(params[:iDisplayLength]).select(:id, :created_at, :gender, :last_name, :customer_id, :first_name, :mobile_number, :email, :date_of_birth, :status, :is_hypertensive, :diabetic, :is_obese, :is_over_weight).order(created_at: :desc)
    @customer.each do |customer|
      # customer.class_eval do
      #   attr_accessor :is_hypertensive
      #   attr_accessor :is_diabetic
      #   attr_accessor :is_obesity
      #   attr_accessor :is_overweight
      # end

      @is_hypertensive = self.has_hypertension customer.id
      @is_diabetic = self.is_diabetic customer.id

      if self.obesity_overweight_checkup(customer) ==3
        @is_overweight = "OverWeigth"
      else
        @is_overweight = "No"
      end

      if self.obesity_overweight_checkup(customer)==4
        @is_obesity = "Obese"
      else
        @is_obesity = "No"
      end
      @cust = Customer.find(customer.id)
      @cust.update(is_hypertensive: @is_hypertensive.to_s, diabetic:  @is_diabetic.to_s, is_obese: @is_obesity.to_s, is_over_weight: @is_overweight.to_s)
    end
    @customer = @customers_temp.page((params[:iDisplayStart].to_i/params[:iDisplayLength].to_i) + 1).per(params[:iDisplayLength]).select(:id, :created_at, :gender, :last_name, :customer_id, :first_name, :mobile_number, :email, :date_of_birth, :status, :is_hypertensive, :diabetic, :is_obese, :is_over_weight).order(created_at: :desc)
    render json: { aaData: JSON.parse(@customer.to_json()), iTotalRecords: Customer.count, iTotalDisplayRecords: @customers_temp.size }
  end

  def obesity_overweight_checkup customer
    if(self.bmi_customer(customer).to_f<18.5)
      return 1#underweight
    elsif((18.5..23.9).include?(self.bmi_customer(customer).to_f))
      return 2#healthy
    elsif((24..26.9).include?(self.bmi_customer(customer).to_f))
      return 3#overweight
    elsif((self.bmi_customer(customer).to_f>=27))
      return 4#obese
    else
      return 0
    end
  end

  def bmi_customer customer
    begin
      inches = (CustomerVitals.find_by(customer_id: customer.id.to_s).feet * 12) + CustomerVitals.find_by(customer_id: customer.id.to_s).inches
      height_in_meters = (inches * 0.0254)
      weight = CustomerVitals.find_by(customer_id: customer.id.to_s).weight.to_i
      bmi = (weight / (height_in_meters * height_in_meters)).to_i
    rescue
      '-'
    end
  end

  def is_diabetic customer_id
    customer = Customer.find(customer_id)
    assessments =  customer.health_assessments.recent_body_assessment.first
    if assessments
      blood_glucose=LabTest.find_by("lower(name)='blood glucose' and enterprise_id=?", assessments.enterprise_id ? assessments.enterprise_id : self.default_enterprise)
      blood_glucose.test_components.each do |test_component|
        result_color=self.resulted_component_value1(test_component.name, customer)[:color]
        if(result_color=='text-warning' or result_color=='text-danger')
          return "Diabetic"
        end
      end
    end
    return "No"
  end

  def has_hypertension customer_id
    if abnormal_bp customer_id
      return "Hypertensive"
    end
    return "No"
  end

  def abnormal_bp customer_id
    customer = Customer.find(customer_id)
    assessments =  customer.health_assessments.recent_body_assessment.first
    if assessments
      blood_glucose=LabTest.find_by("lower(name)='blood pressure' and enterprise_id=?", assessments.enterprise_id ? assessments.enterprise_id : self.default_enterprise)
      blood_glucose.test_components.each do |test_component|
        result_color=self.resulted_component_value1(test_component.name, customer)[:color]
        if(result_color=='text-warning' or result_color=='text-danger')
          return true
        end
      end
    end
    return false
  end

  def upload_avatar
    @customer = Customerfind(params[:id])
    @customer.image = params[:file]
    if @customer.save!
      render :status => 200, :json => { :message => "Success" }
    else
      render :status => 422, :json => { :error => "invalid file format" }
    end
  end

  def update_customer_vitals
    @customer_vitals = CustomerVitals.find_by_customer_id(params[:id])
    respond_to do |format|
      if @customer_vitals.update_attributes(customer_vitals_params)
        format.json {render :status => 200, :json => { :message => "Success" }}
      else
        format.json {render :status => 400, :json => { :error => "Customer Vitals not updated" }}
      end
    end
  end

  def score_graph
    @customer = Customer.find(params[:id])
    @diabetic_score = diabetic_score
    @score_array = Array.new
    [1,2,3,4].each do |year|
      @hyper_tension_scores=Hash.new()
      @hyper_tension_score=hypertension_score(year).round(3)
      @hyper_tension_scores['year_'+year.to_s]=(@hyper_tension_score*100).round
      @score_array.push(@hyper_tension_scores)
    end
    render json: {diabetic_score: @diabetic_score, hypertension_score: @score_array}
  end


  def diabetic_score
    risk_factor=0
    begin
      @age=age['year'].to_i
      @gender=@customer.gender
      @waist = @customer.customer_vitals.waist
      @waist_cm = @waist/0.39370 rescue 0
      @exercise_frequency=@customer.frequency_of_exercise
      @mother_medical_history=@customer.family_medical_histories.where(relation:'Mother')
      @father_medical_history=@customer.family_medical_histories.where(relation:'Father')
      unless @mother_medical_history.nil?
        @mother_diabetes_status=@customer.family_medical_histories.where(relation:'Mother').first.is_diabetic?
      end
      unless @father_medical_history.nil?
        @father_diabetes_status=@customer.family_medical_histories.where(relation:'Father').first.is_diabetic?
      end
      risk_factor +=20 if(@age.between?(35,49))
      risk_factor +=30 if(@age>=50)
      risk_factor +=10 if(@waist_cm.between?(80,89) and @gender=="Female")
      risk_factor +=10 if(@waist_cm.between?(90,99) and @gender=="Male")
      risk_factor +=20 if(@waist_cm>=90 and @gender=="Female")
      risk_factor +=20 if(@waist_cm>=100 and @gender=="Male")
      risk_factor +=20 if(@exercise_frequency=='Occasionally' or @exercise_frequency=='Occasional')
      risk_factor +=30 if(@exercise_frequency=='No' or @exercise_frequency=='Never' or @exercise_frequency=='None')
      if(@mother_diabetes_status and @father_diabetes_status)
        risk_factor +=20
      elsif(@mother_diabetes_status or @father_diabetes_status)
        risk_factor +=10
      end
      return risk_factor
    rescue
      return risk_factor=0
    end
  end

  def age
    today = Date.today
    date_of_birth = @customer.date_of_birth
    error_hash = Hash['year', '-', 'month', '-']

    begin
      year = today.month < date_of_birth.month ? (today.year - date_of_birth.year) - 1 : (today.year - date_of_birth.year)
      month = today.month < date_of_birth.month ? 12 - ((today.month - date_of_birth.month).abs) : (today.month - date_of_birth.month)
      return Hash['year', year, 'month', month]
    rescue
      error_hash
    end
  end

  def hypertension_score(year)
    hypertension_risk_factor=0
    intercept=22.949536
    scale=0.876925
    parameters=Hash.new
    begin
      parameters['age']=age['year'].to_i
      parameters['gender']=GENDER_VALUE[@customer.gender.to_s]
      parameters['bmi']=bmi
      parameters['sbp']=systolic[:result]
      parameters['dbp']=diastolic[:result]
      parameters['smoke']=SMOKE_VALUE[@customer.smoke.to_s]
      parameters['parental_value']=parent_hypertension_value
      parameters['res']=parameters['age']*parameters['dbp'].to_i
      raise 'empty value exception' unless(parameters.all? {|k,v| !v.nil?})

      hypertension_risk_factor +=intercept
      hypertension_risk_factor += BETA_VALUES[:age]*parameters['age']
      hypertension_risk_factor += BETA_VALUES[:gender]*parameters['gender']
      hypertension_risk_factor += BETA_VALUES[:bmi]*parameters['bmi']
      hypertension_risk_factor += BETA_VALUES[:sbp]*parameters['sbp'].to_f
      hypertension_risk_factor += BETA_VALUES[:dbp]*parameters['dbp'].to_f
      hypertension_risk_factor += BETA_VALUES[:parental]*parameters['parental_value'].to_f
      hypertension_risk_factor += BETA_VALUES[:smoke]*parameters['smoke'].to_f
      hypertension_risk_factor += BETA_VALUES[:age_dbp]*parameters['res'].to_f
      risk_factor = calculate_value(year,scale,hypertension_risk_factor)
      return risk_factor
    rescue
      return 0
    end
  end

  def calculate_value years,scale,result
    begin
      log_value=Math::log(years.to_i)
      value=(log_value-result)/scale
      risk_factor=1-Math.exp(-Math.exp(value))
      return risk_factor
    rescue
      return 0
    end
  end

  def parent_hypertension_value
    @mother_medical_history=@customer.family_medical_histories.where(relation:'Mother')
    @father_medical_history=@customer.family_medical_histories.where(relation:'Father')
    unless @mother_medical_history.empty?
      @mother_hypertension_status=@customer.family_medical_histories.where(relation:'Mother').first.has_hypertension?
    end
    unless @father_medical_history.empty?
      @father_hypertension_status=@customer.family_medical_histories.where(relation:'Father').first.has_hypertension?
    end
    if(@mother_diabetes_status and @father_diabetes_status)
      return 2
    elsif(@mother_diabetes_status or @father_diabetes_status)
      return 1
    else
      return 0
    end
  end

  def bmi
    begin
      inches = (@customer.customer_vitals.feet * 12) + @customer.customer_vitals.inches
      height_in_meters = (inches * 0.0254)
      weight = @customer.customer_vitals.weight.to_i
      bmi = (weight / (height_in_meters * height_in_meters)).to_i
    rescue
      '-'
    end
  end

  #systolic and diastolic comes under blood pressure
  def systolic
    resulted_component_value 'Systolic'
  end

  def diastolic
    resulted_component_value 'Diastolic'
  end

  def default_enterprise
    @default_enterprise = Enterprise.find_by(enterprise_id: 'EK')
    return @default_enterprise_id = @default_enterprise.id
  end

  def resulted_component_value1 component_name, customer
    begin
      assessments = customer.health_assessments.body_assessment_done
      assessments.each do |assessment|
        assessment.lab_results.each do |lab_result|
          component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          if lab_result.test_component_id == component.id
            return {result: lab_result.result, color: lab_result.colored_value, units: component.units, date: assessment.request_date}
          end
        end
      end
      {result: '-', color: '', units: ''}
    rescue
      {result: '-', color: '', units: ''}
    end
  end

  def resulted_component_value component_name
    begin
      assessments = @customer.health_assessments.body_assessment_done
      assessments.each do |assessment|
        assessment.lab_results.each do |lab_result|
          component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          if lab_result.test_component_id == component.id
            return {result: lab_result.result, color: lab_result.colored_value, units: component.units, date: assessment.request_date}
          end
        end
      end
      {result: '-', color: '', units: ''}
    rescue
      {result: '-', color: '', units: ''}
    end
  end

  BETA_VALUES={
      age:-0.156412,
      gender:-0.202933,
      bmi:-0.033881,
      sbp:-0.05933,
      dbp:-0.128468,
      smoke:-0.190731,
      parental:-0.166121,
      age_dbp:0.001624
  }
  GENDER_VALUE={'Male'=>0,'Female'=>1}
  SMOKE_VALUE={'Frequently'=>1,'Often'=>1,'Occasional'=>1, 'Occasionally'=>1,'No'=>0, 'None'=>0, 'Never'=>0}

  def timeline
    @customer = Customer.find(params[:id])
    @timeline = Timeline.joins("inner join health_assessments h on h.id=timelines.associated_id where h.customer_id=#{@customer.id} and activity_type in ('BodyAssessment', 'DentalAssessment', 'VisionAssessment') order by timelines.updated_at DESC")
    @timeline.each do |timeline|
      timeline.class_eval do
        attr_accessor :doctor_name
        attr_accessor :provider_name
      end
      assessment = HealthAssessment.find_by_health_assessment_id(timeline.badge) ? HealthAssessment.find_by_health_assessment_id(timeline.badge) : ''
      if assessment!=''
        timeline.doctor_name = assessment.doctor_name
        appointments = Appointment.find_by_appointmentee_id(assessment.id)
        if appointments
          appointment_provider = AppointmentProvider.find_by_appointment_id(appointments.id)
          if appointment_provider.present?
            if appointment_provider.provider_id>0
              provider_name = Provider.find(appointment_provider.provider_id) rescue nil
              if provider_name
                enterprise_name = Enterprise.find(provider_name.enterprise_id).name rescue nil
                timeline.provider_name= enterprise_name
              else
                timeline.provider_name = 'At Home'
              end
            else
              timeline.provider_name = 'At Home'
            end
          else
            timeline.provider_name = 'At Home'
          end
        else
          timeline.provider_name= nil
        end
      else
        timeline.doctor_name = nil
        timeline.provider_name = nil
      end
    end

    render json: {timeline: @timeline}.to_json(:methods => [:doctor_name, :provider_name])
  end

  def family_medical_history
    @customer = Customer.find(params[:id])
    @family_medical_history = @customer.family_medical_histories.create(relation: params[:relation], customer_id: @customer.id)
    @insertion_status=insert_family_medical_history(@family_medical_history,params[:chk_family_medicals])
    if @family_medical_history and @insertion_status
      render :status => 200, :json => { :message => "Success" }
    else
      render :status => 400, :json => { :message => "Medical history not inserted" }
    end
  end

  def body_assessment_list
    @customer = Customer.find(params[:id])
    @assessments = HealthAssessment.where(customer_id: @customer.id, type: 'BodyAssessment', status: 'done')
    @assessments.each do |assessment|
      assessment.class_eval do
        attr_accessor :provider_name
      end
      appointments = Appointment.find_by_appointmentee_id(assessment.id)
      if appointments
        appointment_provider = AppointmentProvider.find_by_appointment_id(appointments.id)
        if appointment_provider.present?
          if appointment_provider.provider_id>0
            provider_name = Provider.find(appointment_provider.provider_id) rescue nil
            if provider_name
              enterprise_name = Enterprise.find(provider_name.enterprise_id).name rescue nil
              assessment.provider_name= enterprise_name
            else
              assessment.provider_name = 'At Home'
            end
          else
            assessment.provider_name = 'At Home'
          end
        else
          assessment.provider_name = 'At Home'
        end
      else
        assessment.provider_name= nil
      end
    end

    render json: {assessments: @assessments}.to_json(:methods => :provider_name)
  end

  def body_assessment
    @assessment = HealthAssessment.find(params[:id])
    @customer = Customer.find(@assessment.customer_id)
    @assessment.class_eval do
      attr_accessor :provider_name
    end
    appointments = Appointment.find_by_appointmentee_id(@assessment.id)
    if appointments
      appointment_provider = AppointmentProvider.find_by_appointment_id(appointments.id)
      if appointment_provider.present?
        if appointment_provider.provider_id > 0
          provider_name = Provider.find(appointment_provider.provider_id) rescue nil
          if provider_name
            enterprise_name = Enterprise.find(provider_name.enterprise_id).name rescue nil
            @assessment.provider_name= enterprise_name
          else
            @assessment.provider_name = 'At Home'
          end
        else
          @assessment.provider_name = 'At Home'
        end
      else
        @assessment.provider_name = 'At Home'
      end
    else
      @assessment.provider_name= nil
    end

    if @assessment.categorize_components.nil? or @assessment.categorize_components.empty?
      @list = nil
      render json: {assessment_info: @list}.to_json(:methods => :provider_name)
    else
      @lab_info = Array.new
      @assesmentHash = Hash.new
      @assesmentHash['assessment'] = @assessment
      @assessment.categorize_components.each do |lab_test_name, test_components|
        @mainHash = Hash.new
        @test_componentsArray = Array.new
        @lab_test_name = lab_test_name
        @test_components = test_components
        if @assessment
          if @assessment.appointments.first
            if @assessment.appointments.first.get_enterprise_id
              enterprise_id =@assessment.appointments.first.get_enterprise_id
              @lab_test_info = LabTest.find_by(name: lab_test_name, enterprise_id: enterprise_id ? enterprise_id : Enterprise.find_by_enterprise_id('EK')).info rescue nil
            else
              @lab_test_info = LabTest.find_by(name: lab_test_name, enterprise_id: Enterprise.find_by_enterprise_id('EK')).info rescue nil
            end
          else
            @lab_test_info = LabTest.find_by(name: lab_test_name, enterprise_id: Enterprise.find_by_enterprise_id('EK')).info rescue nil
          end
        end
        @mainHash['lab_test_name'] = @lab_test_name
        @mainHash['lab_test_info'] = @lab_test_info

        @test_components.each_with_index do |lab_result,index|
          @componentHash = Hash.new
          @info = lab_result.info
          @componentHash['test_component_name']=@info[:test_component_diff][:name]
          @componentHash['test_component_info']=@info[:test_component][:info]
          @componentHash['result_value']=@info[:test_component_diff][:value]
          @componentHash['units']=@info[:test_component_diff][:units]
          @componentHash['idealRange'] = @customer.standard_range(@info[:test_component_diff][:name]).split(',')[1]
          @componentHash['color']=@customer.resulted_component_value1(@info[:test_component_diff][:name], @info[:test_component_diff][:value], @assessment.id)[:color]
          @componentHash['lab_result_increased'] = @info[:test_component].lab_result_increased?(@customer)
          @componentHash['result_history'] = @info[:test_component].test_component_values(@customer)
          @test_componentsArray.push(@componentHash)
          @mainHash['test_component'] = @test_componentsArray
        end
        @lab_info.push(@mainHash)
      end
      @assesmentHash['assessments_lab_info'] = @lab_info
      render json: {assessment_info: @assesmentHash}.to_json(:methods => :provider_name)
    end
    # lab_test_name: @lab_test_name, test_components: @test_components, lab_test_info: @lab_test_info,

  end

  def insert_family_medical_history (family_history,medical_conditions)
    if medical_conditions=="null"
      return true
    end
    begin
      medical_conditions.split(",").each do |medical|
        FamilyMedicalCondition.create(family_medical_history_id:family_history.id, medical_condition_id:medical)
      end
    rescue
      return false
    end
    return true
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :date_of_birth, :daily_activity, :frequency_of_exercise,
                                     :gender, :martial_status, :language_spoken, :ethnicity, :smoke, :alcohol, :medical_insurance, :customer_type, :diet,
                                     :religious_affiliation, :mobile_number, :alternative_mobile_number, :number_of_children,
                                     addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code],
                                     customer_vitals_attributes: [:weight, :feet, :inches, :blood_group_id, :waist])
  end

  def customer_vitals_params
    params.require(:customer_vitals).permit(:weight, :feet, :inches, :blood_group_id, :customer_id, :waist)
  end

  def blood_groups
    render json: BloodGroup.all
  end
end
