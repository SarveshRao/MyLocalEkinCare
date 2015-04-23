class Correction < ActiveRecord::Base
  belongs_to :prescription
  has_one :vision_component, dependent: :destroy

  accepts_nested_attributes_for :prescription
  attr_accessor :left_eye, :right_eye
end
