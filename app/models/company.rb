class Company < ActiveRecord::Base
  has_many :addresses, as: :addressee
  has_one :staff, as: :admin
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :staff

  def address
    address = self.addresses.first
  end
end
