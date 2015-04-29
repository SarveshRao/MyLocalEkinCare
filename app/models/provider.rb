class Provider < ActiveRecord::Base
  has_one :appointment_provider
  has_one :appointment, through: :appointment_provider
  has_one :staff, as: :admin
  has_many :addresses, as: :addressee
  has_many :medications
  belongs_to :enterprise
  has_many :provider_tests	   	
  accepts_nested_attributes_for :staff
  accepts_nested_attributes_for :addresses

  def self.authenticate(email)
    provider = Provider.find_by(email: email)
  end

  # def email=(raw_email)
  #   unless raw_email?
  #     self[:email]= raw_email.downcase
  #   end
  # end

  def gender_default_icon
    'avatar-m.png'
  end

  def address
    address = self.addresses.first
  end
end
