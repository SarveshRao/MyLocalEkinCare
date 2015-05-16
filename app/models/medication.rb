class Medication < ActiveRecord::Base
  belongs_to :drug
  belongs_to :customer
  belongs_to :provider

  default_scope ->{ order('created_at DESC')}
end
