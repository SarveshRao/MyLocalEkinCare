class LabTest < ActiveRecord::Base
  has_many :test_components

  def self.search(search)
    if search.nil? || search.empty?
      self.all
          .order('name ASC')
    else
      self.where("LOWER(name) LIKE :search OR LOWER(info) LIKE :search" , search: "%#{search.downcase}%")
          .order('name ASC')
    end
  end

  def self.search(enterprise_id, search)
    if search.nil? || search.empty?
      self.where(enterprise_id: enterprise_id)
          .order('name ASC')
    else
      self.where(enterprise_id: enterprise_id)
          .where("LOWER(name) LIKE :search OR LOWER(info) LIKE :search" , search: "%#{search.downcase}%")
          .order('name ASC')
    end
  end

end
