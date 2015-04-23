class Vital < ActiveRecord::Base
  belongs_to :customer
  belongs_to :blood_group
  belongs_to :vital_list
end
