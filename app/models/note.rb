class Note < ActiveRecord::Base
  belongs_to :health_assessment

  default_scope -> { order('id DESC') }
end
