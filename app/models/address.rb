class Address < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :addressee, polymorphic: true
  belongs_to :partner

  geocoded_by :zip_code   # can also be an IP address
  after_validation :geocode

  def details
    line1 = is_empty?(self.line1) ? nil : "#{self.line1},"
    line2 = is_empty?(self.line2) ? nil : "#{self.line2},"
    city = is_empty?(self.city) ? nil : "#{self.city},"
    state = is_empty?(self.state) ? nil : "#{self.state},"
    country = is_empty?(self.country) ? nil : "#{self.country},"
    zip_code = is_empty?(self.zip_code) ? nil : "#{self.zip_code}."
    address_in_detail = "#{line1} #{line2} #{city} #{state} #{country} #{zip_code}"
    address_in_detail.gsub!(/(\s)+/, ' ').gsub!(/[\s\,]*$/, '')
  end

  def venus(distance, service)
    Address.select("enterprises.name,branch").joins("inner join providers on providers.id::text = addresses.addressee_id inner join enterprises on enterprises.id = providers.enterprise_id and addressee_type='Provider' and enterprises.service_type='#{service}'").near([self.latitude,self.longitude], distance, :units => :km)
  end

  def venus1(distance)
    Address.select("enterprises.name,branch").joins("inner join providers on providers.id::text = addresses.addressee_id inner join enterprises on enterprises.id = providers.enterprise_id and addressee_type='Provider'").near([self.latitude,self.longitude], distance, :units => :km)
  end

end
