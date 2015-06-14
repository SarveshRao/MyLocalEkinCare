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
    Address.select("enterprises.name,branch").joins("inner join providers on providers.id::text = addresses.addressee_id inner join enterprises on enterprises.id = providers.enterprise_id and addressee_type='Provider' and enterprises.service_type='#{service}' and provider_id!=''").near([self.latitude,self.longitude], distance, :units => :km)
  end

  def venus2(distance, service, enterprise_id)
    Address.select("enterprises.name,branch").joins("inner join providers on providers.id::text = addresses.addressee_id inner join enterprises on enterprises.id = providers.enterprise_id and addressee_type='Provider' and enterprises.enterprise_id='#{enterprise_id}' and enterprises.service_type='#{service}' and provider_id!=''").near([self.latitude,self.longitude], distance, :units => :km)
  end

  def venus1(distance)
    Address.select("enterprises.name,branch").joins("inner join providers on providers.id::text = addresses.addressee_id inner join enterprises on enterprises.id = providers.enterprise_id and addressee_type='Provider' and provider_id!=''").near([self.latitude,self.longitude], distance, :units => :km)
  end

  def get_customers(distance, ids, lat, long, customer_id)
    Address.select("customers.first_name, mobile_number").joins("inner join customers on customers.id::text = addresses.addressee_id inner join customer_vitals on customers.id::text=customer_vitals.customer_id").where("addressee_type='Customer' and customer_vitals.blood_group_id in (#{ids}) and addresses.addressee_id!='#{customer_id}' and blood_sos_on_off=1").near([lat,long], distance, :units => :km)
  end

end
