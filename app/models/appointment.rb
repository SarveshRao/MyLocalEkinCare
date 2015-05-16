class Appointment < ActiveRecord::Base
  include ApplicationHelper

  has_one :appointment_provider, autosave: true
  has_one :provider, through: :appointment_provider, autosave: true

  belongs_to :appointmentee, polymorphic: true

  after_create :create_activity
  after_update :update_status_activity
  before_destroy :delete_inbox_messages

  attr_reader :health_assessment_id

  validates :appointment_date, presence: true
  validates :time, presence: true

  accepts_nested_attributes_for :appointment_provider, :appointmentee

  default_scope { order('id DESC') }
  scope :recent, -> (n) { order('updated_at desc').limit(n) }

  def customer
    assessment.customer
  end

  def delete_inbox_messages
    appointed_customer.inbox_messages.appointment_msg(self.id).delete_all
  end

  def assessment
    self.appointmentee
  end

  def is_partner?
    !self.customer_address
  end

  def get_enterprise_id
    if is_partner?
      if self.appointment_provider.present?
        return enterprise_id =  self.appointment_provider.provider.enterprise_id rescue nil
      end
    else
      if self.appointment_provider.present?
        return enterprise_id =  self.appointment_provider.provider.enterprise_id rescue nil
      end
    end
  end

  def partner_name1
    begin
      if is_partner?
        if self.appointment_provider.present?
          if self.appointment_provider.provider
            enterprise_id =  self.appointment_provider.provider.enterprise_id
            return name = Enterprise.find(enterprise_id).name
          else
            return 'At Home'
          end
        end
      else
        if self.appointment_provider.present?
          if self.appointment_provider.provider
            enterprise_id =  self.appointment_provider.provider.enterprise_id
            return name = Enterprise.find(enterprise_id).name
          else
            return 'At Home'
          end
        else
          return 'At Home'
        end
      end
    rescue
      puts 'no provider found'
    end

  end

  def partner_name
    begin
      if is_partner?
        if self.appointment_provider.present?
          enterprise_id =  self.appointment_provider.provider.enterprise_id
          return name = Enterprise.find(enterprise_id).name
        end
      else
        return 'At Home'
      end
    rescue
      puts 'no provider found'
    end

  end

  def partner_address
    self.appointment_provider.provider.addresses.first
  end

  def customer_addressee
    customer.addresses.first
  end

  def location
    is_partner? ? partner_address : customer_addressee
  end

  def appointment_location
    begin
      if is_partner?

        return partner_address().details

      else
        return customer_addressee().details
      end
    rescue
      puts 'No partner address found '
    end
  end

  def partner_id
    if is_partner?
      begin
        return self.appointment_provider.provider.provider_id
      rescue
        puts 'No appointment provider found'
      end
    else
      return 'At Home'
    end
  end

  def provider_id
    is_partner? ? self.appointment_provider.provider.id : 0
  end

  def date
    d = self.appointment_date
    t = Time.parse(self.time)
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
  end

  def create_activity
    title = "New #{assessment.assessment_type.downcase} assessment scheduled"
    badge = assessment.health_assessment_id
    description = ''
    activity = appointed_customer.activities.create(activity_type: self.class.name, action: :create, associated_id: self.id, title: title, description: description, badge: badge)
    appointed_customer.inbox_messages.create(activity_type: self.class.name, action: :create, associated_id: self.id, title: title, description: description, badge: badge, associated_date: self.date)
    # "Sending SMS to mobile"
    result = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ self.customer.mobile_number() +'&sender=EKCARE&message=CONFIRMATION: Dear '+ self.customer.first_name() +', your EKINCARE '+ appointmentee.assessment_type() +' check up (APPT ID: '+ assessment.health_assessment_id().to_s() +'), is scheduled for '+ formatted_date(self.date) +' at '+ (appointment_provider ? appointment_provider.provider.addresses.first.details() : 'Home') +'. Call 8886783546 for questions. Please carry a copy of valid ID proof for the appointment')))
    notify_create_appointment activity
  end

  def notify_create_appointment activity
    Notification.appointment_create_notifier(self.customer, activity, self).deliver!
  end

  def notify_update_appointment activity
    Notification.appointment_update_notifier(self.customer, activity, self).deliver!
  end

  def update_status_activity
    title = "#{assessment.assessment_type} assessment rescheduled"
    badge = assessment.health_assessment_id
    description = ''
    activity = appointed_customer.activities.create(activity_type: self.class.name, action: :update, associated_id: self.id, title: title, description: description, badge: badge)
    appointed_customer.inbox_messages.create(activity_type: self.class.name, action: :update, associated_id: self.id, title: title, description: description, badge: badge, associated_date: self.date)
    # "Sending SMS to mobile"
    result = Net::HTTP.get(URI.parse(URI.encode('http://alerts.sinfini.com/api/web2sms.php?workingkey=A3b834972107faae06b47a5c547651f81&to='+ self.customer.mobile_number() +'&sender=EKCARE&message=CONFIRMATION: Dear '+ self.customer.first_name() +', your EKINCARE '+ appointmentee.assessment_type() +' check up (APPT ID: '+ assessment.health_assessment_id().to_s() +'), is RESCHEDULED for '+ formatted_date(self.date) +' at '+ (appointment_provider.provider ? appointment_provider.provider.addresses.first.details() : 'Home') +'. Call 8886783546 for questions. Please carry a copy of valid ID proof for the appointment')))
    notify_update_appointment activity
  end

  def is_customer_appointment?
    self.appointmentee_type == 'Customer'
  end

  def appointed_customer
    is_customer_appointment? ? self.appointmentee : self.appointmentee.customer
  end
end
