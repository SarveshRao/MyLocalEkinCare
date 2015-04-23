class Inbox < ActiveRecord::Base
  belongs_to :customer

  scope :appointments, -> { where("associated_date >= ? AND activity_type = ?", Date.today, 'Appointment').order('associated_date ASC') }
  scope :recommendations, -> { where("activity_type = Recommendation").order('associated_date ASC') }
  scope :recommend_msg, -> (rec_id){ where(activity_type: 'Recommendation', associated_id: rec_id)}
  scope :appointment_msg, -> (apt_id){ where(activity_type: 'Appointment', associated_id: apt_id)}

  def appointment
    if is_appointment_message?
      appointment = Appointment.find(self.associated_id)
    end
    appointment
  end

  def recommendation
    if is_recommendation_message?
      recommendation = Recommendation.find(self.associated_id)
    end
    recommendation
  end

  def is_recommendation_message?
    self.activity_type == 'Recommendation'
  end

  def is_appointment_message?
    self.activity_type == 'Appointment'
  end
end
