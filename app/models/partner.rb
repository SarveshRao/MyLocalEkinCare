class Partner < ActiveRecord::Base

 has_many :promo_codes
 has_one :address
 validates :code,:title,:email,presence:true
 validates :code,:email,uniqueness:true
end
