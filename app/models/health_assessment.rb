class HealthAssessment < ActiveRecord::Base
  include ApplicationHelper
  attr_accessor :enterprise_name
  belongs_to :customer
  has_many :notes
  has_many :appointments, as: :appointmentee
  has_many :recommendations, as: :recommend
  has_many :medical_records, as: :record
  has_many :health_assessment_promo_codes
  has_many :promo_codes, :through=>:health_assessment_promo_codes

  default_scope -> { order('request_date DESC, id DESC') }
  scope :recent, -> (n) { order('updated_at desc').limit(n) }
  scope :newly_requested, ->{order('status_code ASC')}
  scope :requested, -> { order('request_date DESC') }
  scope :recent_assessment_type, ->{ order('created_at DESC').limit(1)}
  scope :recent_assessment_body, ->{where("assessment_type = ?", 'Body')}
  scope :recent_health_assessment, ->{where("status = ?", 'done').order('request_date DESC').limit(1)}
  scope :recent_body_assessment, -> { where("assessment_type = ? AND status = ?", 'Body', 'done').order('request_date DESC') }
  scope :dental_assessment_done, -> { where(type: 'DentalAssessment', status: 'done').order('request_date DESC') }
  scope :vision_assessment_done, -> { where(type: 'VisionAssessment', status: 'done').order('request_date DESC') }
  scope :body_assessment_done, -> { where(type: 'BodyAssessment', status: 'done').order('request_date DESC') }
  scope :emr_above_status_assessments, -> { where("status = ? ", 'done').order('request_date DESC') }
  # scope :next_or_prev_month, -> (n) { where(updated_at: 30.days.ago..-30.days.ago).order('updated_at desc').limit(n) }

  validates :assessment_type, presence: true
  before_create :set_assessment_type, :check_request_date
  after_create :create_examination, :set_unique_id, :create_activity
  before_update :set_assessment_type, :drop_examination, :check_request_date
  after_update :update_status_activity


  STATES = ['requested', 'sample_collection', 'test_phase', 'test_results', 'update_emr', 'second_review','done']
  def drop_examination
    if self.assessment_type_was != self.assessment_type
      construct_dental_examination
    end
  end

  def construct_dental_examination
    if self.type == 'DentalAssessment'
      Examination.create!(dental_assessment_id: self.id)
    elsif self.type_was == 'DentalAssessment'
      self.examination.delete
    end
  end

  def create_examination
    if self.assessment_type == 'Dental'
      Examination.create!(dental_assessment_id: self.id)
    end
  end

  def check_request_date
    self.request_date = self.request_date || Date.today
  end

  def set_unique_id
    self.health_assessment_id = generate_random_unique_identifer
    self.save
  end

  def set_assessment_type
    self.type = self.assessment_type.empty? ? 'HealthAssessment' : "#{self.assessment_type}Assessment"
  end

  def generate_random_unique_identifer
    rand_num = SecureRandom.random_number(999999)
    identifier = "HA#{padding_zeros(rand_num, 6)}"

    if HealthAssessment.exists?(health_assessment_id: identifier)
      generate_random_unique_identifer
    end

    identifier
  end

  def addresses
    self.customer.addresses
  end

  state_machine :status, :initial => :requested do

    state :requested do
      def status_message
        "New Request"
      end
    end

    state :sample_collection do
      def status_message
        "Sample colletion / Document gathering"
      end
    end

    state :test_phase do
      def status_message
        "Test Phase"
      end
    end

    state :test_results do
      def status_message
        "Test Results"
      end
    end

    state :update_emr do
      def status_message
        "Update EMR"
      end
    end

    state :second_review do
      def status_message
        "Second Review"
      end
    end

    state :done do
      def status_message
        "Done"
      end
    end

    event :sample_collection do
      transition :requested => :sample_collection
    end

    event :test_phase do
      transition :sample_collection => :test_phase
    end

    event :test_results do
      transition :test_phase => :test_results
    end

    event :update_emr do
      transition :test_results => :update_emr
    end

    event :second_review do
      transition :update_emr => :second_review
    end

    event :done do
      transition :second_review => :done
    end

  end

  def notify_assessment activity
    guardian_mail = ''
    if !self.customer.guardian_id.nil?
      guardian_mail = Customer.find(self.customer.guardian_id).email
    end
    Notification.assessment_notifier(self.customer, activity, self, guardian_mail).deliver!
  end


  def update_status_activity
    if self.changed.include?('status') && !self.status_was.nil?
      assessment = add_space(self.type)
      title = "#{assessment}: updated"
      badge = self.health_assessment_id
      description = "#{assessment} status changed from #{ self.status_was } to #{self.status}"
      activity = self.customer.activities.create(activity_type: self.type, action: :update, associated_id: self.id, title: title, description: description, badge: badge)

      record_assessment_done_activity title, badge, description

      if activity
        #notify_assessment activity
      end
    end
  end

  def create_activity
    assessment = add_space(self.type)
    title = 'New Assessment placed'
    badge = self.health_assessment_id
    description = "New #{assessment} "
    activity = self.customer.activities.create(activity_type: self.type, action: :create, associated_id: self.id, title: title, description: description, badge: badge)

    if activity
      record_assessment_done_activity title, badge, description
      #notify_assessment activity
    end
  end

  def record_assessment_done_activity title, badge, description
    if self.status == 'done'
      timeline_title = "#{self.type}"
      timeline_title = add_space(timeline_title)
          timeline_badge = "#{self.health_assessment_id}"
      timeline_description = ''
      self.customer.timeline_activities.create(activity_type: self.type, action: :update, associated_id: self.id, title: timeline_title, description: timeline_description, badge: timeline_badge)
      self.customer.inbox_messages.create(activity_type: self.type, action: :update, associated_id: self.id, title: title, description: description, badge: badge, associated_date: self.request_date)
    end
  end

  def add_space assessment
    spaced_assessment = case assessment
      when 'BodyAssessment' then
        "Body Assessment"
      when 'DentalAssessment' then
        "Dental Assessment"
      when 'VisionAssessment' then
        "Vision Assessment"
    end
    spaced_assessment
  end

  def has_appointments
    return self.appointments.empty?
  end

end
