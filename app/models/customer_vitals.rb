class CustomerVitals < ActiveRecord::Base
  belongs_to :customer
  belongs_to :blood_group
end
