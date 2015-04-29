class Activity < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :customer

  default_scope { order('updated_at DESC') }
  scope :recent, -> { where("created_at BETWEEN ? AND ?", 30.days.ago, -30.days.ago).limit(3) }
end
