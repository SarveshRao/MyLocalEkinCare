class Prescription < ActiveRecord::Base
  belongs_to :vision_assessment
  has_many :corrections, dependent: :destroy

  accepts_nested_attributes_for :corrections

end
