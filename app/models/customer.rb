class Customer < ActiveRecord::Base
  include ApplicationHelper,HealthCalculationsHelper
  mount_uploader :image , ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :validatable

  validates_uniqueness_of :mobile_number

  attr_accessor :otp
  attr_accessor :otp_expire
  attr_accessor :is_customer
  has_many :activities
  has_many :timeline_activities, class_name: 'Timeline'
  has_many :inbox_messages, class_name: 'Inbox'

  has_many :doctor_comments, class_name: 'Comments'

  has_many :customer_allergies
  has_many :allergies, through: :customer_allergies, autosave: true

  has_many :customer_medical_conditions
  has_many :medical_conditions, through: :customer_medical_conditions, autosave: true

  has_many :customer_procedures
  has_many :procedures, through: :customer_procedures

  has_many :customer_immunizations
  has_many :immunizations, through: :customer_immunizations

  has_many :addresses, as: :addressee
  has_many :health_assessments, autosave: true, dependent: :destroy

  has_many :customer_coupons
  has_many :coupons, through: :customer_coupons

  has_many :medications
  has_many :family_medical_histories
  has_one :customer_vitals
  has_many :vitals
  has_many :appointments, as: :appointmentee
  has_many :medical_records, as: :record
  has_many :identities, dependent: :destroy
  has_many :promo_codes

  has_one_time_password
  has_many :doctor_opinions

  accepts_nested_attributes_for :identities

  #validates :first_name, presence: true
  #validates :last_name, presence: true
  #validates :email, presence: true
  #validates :date_of_birth, presence: true
  #validates :password, presence: true
  #validates :license

  belongs_to :blood_group
  belongs_to :guardian, class_name: Customer

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :family_medical_histories
  accepts_nested_attributes_for :customer_vitals

  after_create :generate_cid
  after_update :generate_cid

  default_scope { order('created_at DESC') }
  scope :recent, -> { order('updated_at desc').limit(10) }

  attr_accessor :license

  class << self
    def find_for_oauth(auth, signed_in_resource = nil)
      # Get the identity and customer if they exist
      identity = Identity.find_for_oauth(auth)

      # If a signed_in_resource is provided it always overrides the existing customer
      # to prevent the identity being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated identity) which
      # can be cleaned up at a later date.
      customer = signed_in_resource ? signed_in_resource : identity.customer
    end
  end

  def has_access_to_dashboard?
    if wiz_finishid? && self.health_assessments.count > 0
      true
    else
      false
    end
  end


  def generate_cid
    if !(self.customer_id.to_s.length == 9) && !self.gender.nil?
      loop do
        temp_cust_id = generate_random_formatted_num

        unless Customer.exists?(customer_id: temp_cust_id)
          self.update_columns(customer_id: temp_cust_id)
          break
        end
      end
    end
  end


  def current_state
    status || 'your_health'
  end

  def height
    "#{self.customer_vitals.feet} Feet #{self.customer_vitals.inches} Inches"
  end

  #def weight
  #  "#{self.weight}kgs"
  #end

  def generate_random_formatted_num
    rand_num = SecureRandom.random_number(999999)
    return "EK#{self.gender.slice(0, 1)}#{padding_zeros(rand_num, 6)}"
    #return "EK123"
  end

  def upcoming_assessment
    self.health_assessments.where("request_date > ?", Date.today.to_date).first
  end

  def assessment_score
    assessment_status = ['requested', 'sample_collection', 'test_phase', 'test_results', 'update_emr', 'second_review', 'done']
    weight = self.health_assessments.inject(0) do |weight, health_assessment|
      weight = weight + assessment_status.index(health_assessment.status)
    end
    total_weight = ((weight/(self.health_assessments.count * 6).to_f)*100).to_i
  end

  def gender_default_icon
    if self.gender == 'Male'
      'avatar-m.png'
    else
      'avatar-f.png'
    end
  end

  def age
    today = Date.today
    date_of_birth = self.date_of_birth
    error_hash = Hash['year', '-', 'month', '-']

    begin
      year = today.month < date_of_birth.month ? (today.year - date_of_birth.year) - 1 : (today.year - date_of_birth.year)
      month = today.month < date_of_birth.month ? 12 - ((today.month - date_of_birth.month).abs) : (today.month - date_of_birth.month)
      return Hash['year', year, 'month', month]
    rescue
      error_hash
    end
  end

  def name
    self.first_name + " " + self.last_name rescue '-'
  end

  def address
    address = self.addresses.first
  end

  def dental_assessments
    dental_assessments = self.health_assessments.where(type: 'Dental')

    dental_assessments
  end

  def recent_activities
    self.activities.recent
  end

  #systolic and diastolic comes under blood pressure
  def systolic
    resulted_component_value 'Systolic'
  end

  def diastolic
    resulted_component_value 'Diastolic'
  end

  def bmi
    begin
      inches = (self.customer_vitals.feet * 12) + self.customer_vitals.inches
      height_in_meters = (inches * 0.0254)
      weight = self.customer_vitals.weight.to_i
      bmi = (weight / (height_in_meters * height_in_meters)).to_i
    rescue
      '-'
    end
  end

  def colored_bmi
    begin
      colors = ['text-success', 'text-warning', 'text-danger']
      if self.age['years'].to_i < 25
        result_val = [self.bmi.between?(18, 25), self.bmi.between?(26, 30), eval("#{self.bmi} < 18 || #{self.bmi} > 30")]
      else
        result_val = [self.bmi.between?(19, 25), self.bmi.between?(26, 30), eval("#{self.bmi} < 19 || #{self.bmi} > 30")]
      end

      result_val.each_with_index do |val, index|
        if val
          return colors[index]
        end
      end
    rescue
      ''
    end
  end

  def default_enterprise
    return @default_enterprise_id = Enterprise.find_by(enterprise_id: 'EK').id
  end

  def resulted_component_value component_name
    begin
      assessments = self.health_assessments.body_assessment_done
      assessments.each do |assessment|
        assessment.lab_results.each do |lab_result|
          lonic_code = TestComponent.find_by('lower(name) =?',component_name.downcase).lonic_code
          if lonic_code
            component = TestComponent.where("lonic_code = ? and enterprise_id =?", lonic_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          else
            component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          end
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

  # duplicated for body_assessment in customer side
  def resulted_component_value1 component_name, result_value, assessment_id
    begin
      assessment = HealthAssessment.find(assessment_id)
      assessment.lab_results.each do |lab_result|
        lonic_code = TestComponent.find_by('lower(name) =?',component_name.downcase).lonic_code
        if lonic_code
          component = TestComponent.where("lonic_code = ? and enterprise_id =?", lonic_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
        else
          component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
        end
        if lab_result.test_component_id == component.id
          if lab_result.result == result_value
            return {result: lab_result.result, color: lab_result.colored_value, units: component.units, date: assessment.request_date}
          end
        end
      end
      {result: '-', color: '', units: ''}
    rescue
      {result: '-', color: '', units: ''}
    end
  end

  # duplicated for customer side inline edit
  def resulted_component_value2 component_name, result_value, assessment_id
    begin
      assessment = HealthAssessment.find(assessment_id)
      assessment.lab_results.each do |lab_result|
        lonic_code = TestComponent.find_by('lower(name) =?',component_name.downcase).lonic_code
        if lonic_code
          component = TestComponent.where("lonic_code = ? and enterprise_id =?", lonic_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
        else
          component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
        end
        if lab_result.test_component_id == component.id
          return {result: lab_result.result, color: lab_result.colored_value, units: component.units, date: assessment.request_date}
        end
      end
      {result: '-', color: '', units: ''}
    rescue
      {result: '-', color: '', units: ''}
    end
  end


  def blood_sugar_result(name)
    get_lab_result name
  end

  def get_lab_result component_name
    begin
      assessments = self.health_assessments.body_assessment_done
      assessments.each do |assessment|
        assessment.lab_results.each do |lab_result|
          lonic_code = TestComponent.find_by('lower(name) =?',component_name.downcase).lonic_code
          if lonic_code
            component = TestComponent.where("lonic_code = ? and enterprise_id =?", lonic_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          else
            component = TestComponent.where("lower(name) = ? and enterprise_id =?", component_name.downcase, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise).first
          end
          if lab_result.test_component_id == component.id
            return lab_result
          end
        end
      end
      return LabResult.new
    rescue
      return LabResult.new
    end
  end

  def blood_sugar (name)
    resulted_component_value name
  end

  def insufficient_results
    begin
      rejected_fields = ['Blood Glucose', 'Blood pressure']
      # recent_body_assessment = self.health_assessments.recent_body_assessment.first
      # if !recent_body_assessment.nil?
      #   lab_results = recent_body_assessment.lab_results.map { |lab_result| lab_result.test_component_ranges_diff }
      #   lab_results = lab_results.select { |key, value| key[:bad_range] == true && !key[:color].nil? }
      #   lab_results = lab_results.group_by { |test_component| test_component[:lab_test].name }
      #   lab_results.reject! { |lab_test_name, tc| rejected_fields.include? lab_test_name }
      #   lab_results
      # else
      #   []
      # end
      lab_results = nil
      self.health_assessments.recent_body_assessment.each do |assessment|
        results_count = assessment.lab_results.count
        if results_count > 0
          recent_assessment = assessment
          if !assessment.nil?
            lab_results = assessment.lab_results.map { |lab_result| lab_result.test_component_ranges_diff }
            lab_results = lab_results.select { |key, value| key[:bad_range] == true && !key[:color].nil? }
            lab_results = lab_results.group_by { |test_component| test_component[:lab_test].name }
            lab_results.reject! { |lab_test_name, tc| rejected_fields.include? lab_test_name }
            lab_results
            break
          else
            []
          end
        end
      end
      lab_results
    rescue
      []
    end
  end

  def recent_body_assessment_done
    self.health_assessments.recent_body_assessment.first rescue nil
  end

  def assessment_type
    self.health_assessments.recent_assessment_type.first
  end

  def assessment_body_bp
    body_assessment =  health_assessments.recent_body_assessment
    body_assessment.each do |assessment|
      sys_code = TestComponent.find_by("lower(name)='systolic'").lonic_code
      dia_code = TestComponent.find_by("lower(name)='diastolic'").lonic_code
      if sys_code and dia_code
        component = TestComponent.where("lonic_code IN (#{sys_code},#{dia_code}) and enterprise_id= #{assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise}")
      else
        component = TestComponent.where("lower(name) IN ('systolic','diastolic') and enterprise_id= #{assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise}")
      end
      ids = component.collect(&:id).join(',')
      lab_results = LabResult.where("test_component_id IN (#{ids}) AND body_assessment_id=?", assessment.id).first
      unless lab_results.nil?
        return assessment.request_date
      end
    end
    return '-'
  end

  def blood_pressure
    body_assessment =  health_assessments.recent_body_assessment
    # diastolic=TestComponent.find_by(name:'Diastolic')
    # diastolic_id=diastolic.id rescue '-'
    body_assessment.each do |assessment|
      sys_code = TestComponent.find_by("lower(name)='systolic'").lonic_code
      dia_code = TestComponent.find_by("lower(name)='diastolic'").lonic_code
      if sys_code
        systolic=TestComponent.find_by(lonic_code:sys_code, enterprise_id: assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      else
        systolic=TestComponent.find_by(name:'Systolic', enterprise_id: assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      end
      systolic_id=systolic.id rescue '-'
      if sys_code and dia_code
        component = TestComponent.where("lonic_code IN (#{sys_code},#{dia_code}) and enterprise_id= #{assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise}")
      else
        component = TestComponent.where("lower(name) IN ('systolic','diastolic') and enterprise_id= #{assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise}")
      end
      ids = component.collect(&:id).join(',')
      lab_results = LabResult.where("test_component_id IN (#{ids}) AND body_assessment_id=?", assessment.id).first
      unless lab_results.nil?
        if(lab_results.test_component_id==systolic_id)
          return lab_results.result.to_i
        end
      end
      return false
    end
    return '-'
  end

  def fasting_blood_sugar
    body_assessment =  health_assessments.recent_body_assessment
    body_assessment.each do |assessment|
      fasting_blood_sugar_code = TestComponent.find_by("lower(name)='fasting blood sugar'").lonic_code
      if fasting_blood_sugar_code
        component = TestComponent.find_by("lonic_code=? and enterprise_id=?", fasting_blood_sugar_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      else
        component = TestComponent.find_by("lower(name)='fasting blood sugar' and enterprise_id=?", assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      end
      lab_results = LabResult.where("test_component_id =? AND body_assessment_id=?",component.id, assessment.id).first
      unless lab_results.nil?
        return lab_results.result
      end
    end
    return '-'
  end

  # This is crap to write such a menthd. but no choice.
  def fasting_blood_sugar2
    body_assessment =  health_assessments.recent_body_assessment
    body_assessment.each do |assessment|
      fasting_blood_sugar_code = TestComponent.find_by("lower(name)='fasting blood sugar'").lonic_code
      if fasting_blood_sugar_code
        component = TestComponent.find_by("lonic_code=? and enterprise_id=?", fasting_blood_sugar_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      else
        component = TestComponent.find_by("lower(name)='fasting blood sugar' and enterprise_id=?", assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      end
      lab_results = LabResult.where("test_component_id =? AND body_assessment_id=?",component.id, assessment.id).first
      unless lab_results.nil?
        return {bllod_sugar: lab_results.result, date: assessment.request_date}
      end
    end
    return {bllod_sugar: "", date: ""}
  end

  def assessment_body_sugar
    body_assessment =  health_assessments.recent_body_assessment
    body_assessment.each do |assessment|
      fasting_blood_sugar_code = TestComponent.find_by("lower(name)='fasting blood sugar'").lonic_code
      if fasting_blood_sugar_code
        component = TestComponent.where("lonic_code=? and enterprise_id=?", fasting_blood_sugar_code, assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      else
        component = TestComponent.where("lower(name)='fasting blood sugar' and enterprise_id=?", assessment.enterprise_id ? assessment.enterprise_id : self.default_enterprise)
      end
      ids = component.collect(&:id).join(',')
      lab_results = LabResult.where("test_component_id IN (#{ids}) AND body_assessment_id=?",assessment.id).first
      unless lab_results.nil?
        return assessment.request_date
      end
    end
    return '-'
  end

  def recent_health_assessment_done
    self.health_assessments.recent_health_assessment.first rescue nil
  end

  def recent_body_assessment
    self.health_assessments.recent_body_assessment.first rescue nil
  end

  def documents
    (self.medical_records.flatten + self.health_assessments.collect(&:medical_records).flatten).reverse
  end

  def is_uploaded_documents
    return self.medical_records.empty?;
  end

  def message_box
    (self.inbox_messages.appointments + self.inbox_messages.recommendations)
  end

  def assessment_index type, assessment_id
    self.health_assessments.where(assessment_type: type).each_with_index do |assessment, index|
      if assessment_id.to_i == assessment.id
        return index
      end
    end
    0
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |customer|
      customer.email = auth.info.email
      customer.first_name = auth.info.first_name # assuming the customer model has a first_name
      customer.last_name = auth.info.last_name
      customer.gender = auth.extra.raw_info.gender
      customer.provider = auth.provider
      customer.uid = auth.uid
      customer.password = Devise.friendly_token[0, 20]
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = Customer.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def test_component_history(test_component, current_assessment)
    health_assessments = self.health_assessments.body_assessment_done
    exclude_recent_assessment = health_assessments - [current_assessment]
    lab_results = exclude_recent_assessment.map do |assessment|
      assessment.lab_results.select do |lab_result|
        lab_result.test_component.id == test_component.id
      end
    end
    list_of_lab_results = lab_results.flatten
  end

  def wiz_finishid?
    if ['thank_you_page', 'welcome_page', "wicked_finish"].include?(self.status)
      return true
    else
      return false
    end
  end


  def obesity_overweight_checkup
    if(self.bmi.to_f<18.5)
      return 1#underweight
    elsif((18.5..23.9).include?(self.bmi.to_f))
      return 2#healthy
    elsif((24..26.9).include?(self.bmi.to_f))
      return 3#overweight
    elsif((self.bmi.to_f>=27))
      return 4#obese
    else
      return 0
    end
  end

  def has_cvd
    return false
  end

  def is_diabetic_or_hypertensive component
    assessments =  health_assessments.recent_body_assessment.first
    if assessments
      blood_glucose=LabTest.find_by("lower(name)=? and enterprise_id=?", component.downcase,assessments.enterprise_id ? assessments.enterprise_id : self.default_enterprise)
      blood_glucose.test_components.each do |test_component|
        result_color=self.resulted_component_value(test_component.name)[:color]
        if(result_color=='text-warning' or result_color=='text-danger')
          return true
        end
      end
    end
    return false
  end

  def is_diabetic
    return is_diabetic_or_hypertensive 'Blood Glucose'
  end

  def has_hypertension
    if(self.abnormal_bp)
      return true
    end
    return false
  end

  def has_hypertension1
    if(self.pre_hypertensive)
      return true
    end
    return false
  end

  def systolic_range
    standard_range 'Systolic'
  end

  def diastolic_range
    standard_range 'Diastolic'
  end

  def fasting_blood_sugar_range
    standard_range 'Fasting blood sugar'
  end

  def standard_range test_component_name
    begin
      gender=self.gender[0,1]
      component_code = TestComponent.find_by("lower(name)=?",test_component_name.downcase).lonic_code
      if component_code
        test_component=TestComponent.find_by(lonic_code: component_code)
      else
        test_component=TestComponent.find_by("lower(name)=?",test_component_name.downcase)
      end
      unless(test_component.standard_ranges.nil?)
        standard_range=test_component.standard_ranges.where(gender:gender).first
        return standard_range.range_value
      end
    rescue
      return '-'
    end
  end

  def standard_range1 test_component_name, assessment_id
    begin
      gender=self.gender[0,1]
      component_code = TestComponent.find_by("lower(name)=?",test_component_name.downcase).lonic_code
      if component_code
        test_component=TestComponent.find_by(lonic_code: component_code, enterprise_id: HealthAssessment.find(assessment_id).enterprise_id)
      else
        test_component=TestComponent.find_by("lower(name)=?",test_component_name.downcase, enterprise_id: HealthAssessment.find(assessment_id).enterprise_id)
      end
      unless(test_component.standard_ranges.nil?)
        standard_range=test_component.standard_ranges.where(gender:gender).first
        return standard_range.range_value
      end
    rescue
      return '-'
    end
  end

  def pre_hypertensive
    assessments =  health_assessments.recent_body_assessment.first
    if assessments
      blood_pressure=LabTest.find_by("lower(name)='blood pressure'", enterprise_id: assessments.enterprise_id ? assessments.enterprise_id : self.default_enterprise)
      blood_pressure.test_components.each do |test_component|
        result_color=self.resulted_component_value(test_component.name)[:color]
        if(result_color=='text-warning')
          return true
        end
      end
    end
    return false
  end

  def abnormal_bp
    return self.is_diabetic_or_hypertensive 'Blood pressure'
  end

  def diabetic_score
    risk_factor=0
    begin
      @age=self.age['year'].to_i
      @gender=self.gender
      @waist = self.customer_vitals.waist
      @waist_cm = @waist/0.39370 rescue '-'
      @exercise_frequency=self.frequency_of_exercise
      @mother_medical_history=self.family_medical_histories.where(relation:'Mother')
      @father_medical_history=self.family_medical_histories.where(relation:'Father')
      unless @mother_medical_history.nil?
        @mother_diabetes_status=self.family_medical_histories.where(relation:'Mother').first.is_diabetic?
      end
      unless @father_medical_history.nil?
        @father_diabetes_status=self.family_medical_histories.where(relation:'Father').first.is_diabetic?
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

  def hypertension_score(year)
    hypertension_risk_factor=0
    intercept=22.949536
    scale=0.876925
    parameters=Hash.new
    begin
      parameters['age']=self.age['year'].to_i
      parameters['gender']=GENDER_VALUE[self.gender.to_s]
      parameters['bmi']=self.bmi
      parameters['sbp']=self.systolic[:result]
      parameters['dbp']=self.diastolic[:result]
      parameters['smoke']=SMOKE_VALUE[self.smoke.to_s]
      parameters['parental_value']=self.parent_hypertension_value
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

      return risk_factor=calculate_value(year,scale,hypertension_risk_factor)
    rescue
      return 0
    end
  end

  def mother_has_health_history?
    @mother_medical_history=self.family_medical_histories.where(relation:'Mother')
    return @mother_medical_history.present?
  end

  def father_has_health_history?
    @father_medical_history=self.family_medical_histories.where(relation:'Father')
    return @father_medical_history.present?
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

  def calculate_value years,scale,result
    begin
      log_value=Math::log(years)
      value=(log_value-result)/scale
      risk_factor=1-Math.exp(-Math.exp(value))
      return risk_factor
    rescue
      return 0
    end
  end

  def parent_hypertension_value
    @mother_medical_history=self.family_medical_histories.where(relation:'Mother')
    @father_medical_history=self.family_medical_histories.where(relation:'Father')
    unless @mother_medical_history.empty?
      @mother_hypertension_status=self.family_medical_histories.where(relation:'Mother').first.has_hypertension?
    end
    unless @father_medical_history.empty?
      @father_hypertension_status=self.family_medical_histories.where(relation:'Father').first.has_hypertension?
    end
    if(@mother_diabetes_status and @father_diabetes_status)
      return 2
    elsif(@mother_diabetes_status or @father_diabetes_status)
      return 1
    else
      return 0
    end
  end

  def father_hyper_tension_status
    return @father_hypertension_status
  end

  def mother_hyper_tension_status
    return @mother_hypertension_status
  end

  GENDER_VALUE={'Male'=>0,'Female'=>1}
  SMOKE_VALUE={'Frequently'=>1,'Often'=>1,'Occasional'=>1, 'Occasionally'=>1,'No'=>0, 'None'=>0, 'Never'=>0}
  def self.search(search)
    if search.nil? || search.empty?
      self.all
    else
      self.where("LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search OR mobile_number LIKE :search OR LOWER(customer_id) LIKE :search OR LOWER(email) LIKE :search OR LOWER(is_hypertensive) LIKE :search OR LOWER(diabetic) LIKE :search OR LOWER(is_obese) LIKE :search OR LOWER(is_over_weight) LIKE :search" , search: "%#{search.downcase}%")
    end
  end

  def as_json(options = { })
    h = super(options)
    h[:systolic]   = systolic
    h[:diastolic] = diastolic
    h[:blood_sugar] = fasting_blood_sugar2
    h
  end
  def number_of_documents_uploaded
    return self.documents.count
  end
  def need_two_factor_authentication?(request)
    not otp_secret_key.nil?
  end

  def password_required?
    false
  end
end
