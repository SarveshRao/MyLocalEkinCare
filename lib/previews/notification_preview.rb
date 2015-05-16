class NotificationPreview < ActionMailer::Preview

  def initialize
  @customer = Customer.all.sample
  @appointmnet = Appointment.all.sample
  @recommendation = Recommendation.all.sample
  @assessment = BodyAssessment.all.sample
  @appointment_activity = Activity.where(activity_type: 'Appointment').sample
  @recommendation_activity = Activity.where(activity_type: 'Recommendation').sample
  @assessment_activity = Activity.where(activity_type: 'BodyAssessment').sample
  @staff = Staff.all.sample
  @staff.password = "123456aA"
  end


  #http://localhost:3000/rails/mailers/notification/appointment_create_notifier
  def appointment_create_notifier
    Notification.appointment_create_notifier(@customer, @appointment_activity, @appointmnet)
  end

  #http://localhost:3000/rails/mailers/notification/appointment_update_notifier
  def appointment_update_notifier
    Notification.appointment_update_notifier(@customer, @appointment_activity, @appointmnet)
  end

  #http://localhost:3000/rails/mailers/notification/recommendation_notifier
  def recommendation_notifier
    Notification.recommendation_notifier(@customer, @recommendation_activity, @recommendation)
  end

  #http://localhost:3000/rails/mailers/notification/assessment_notifier
  def assessment_notifier
    Notification.assessment_notifier(@customer, @assessment_activity, @assessment)
  end

  #http://localhost:3000/rails/mailers/notification/staff_account_notifier
  def staff_account_notifier
    Notification.staff_account_notifier(@staff)
  end
end
