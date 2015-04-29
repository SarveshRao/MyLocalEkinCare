class Recommendation < ActiveRecord::Base
  belongs_to :recommend, polymorphic: true

  after_create :create_activity
  before_destroy :delete_inbox_messages
  # after_update :update_status_activity

  default_scope {order('id DESC')}
  scope :recent, -> (n) { order('updated_at desc').limit(n) }

  def delete_inbox_messages
    customer.inbox_messages.recommend_msg(self.id).delete_all
  end

  def customer
    assessment.customer
  end

  def assessment
    self.recommend
  end

  def notify_recommendation activity
    Notification.recommendation_notifier(self.customer, activity, self).deliver!
  end

  def create_activity
    title = "New #{assessment.assessment_type.downcase} recommendation"
    badge = assessment.health_assessment_id
    description = ''
    activity = self.recommend.customer.activities.create(activity_type: self.class.name, action: :create, associated_id: self.id, title: title, description: description, badge: badge)
    self.recommend.customer.inbox_messages.create(activity_type: self.class.name, action: :create, associated_id: self.id, title: title, description: description, badge: badge, associated_date: self.created_at)
    notify_recommendation activity
  end
end
