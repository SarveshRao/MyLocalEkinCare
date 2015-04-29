class RiskFactor < ActiveRecord::Base
  has_many :message_prompts
end
