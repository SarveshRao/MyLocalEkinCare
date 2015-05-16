class Allergy < ActiveRecord::Base
  has_many :customer_allergies
  has_many :customers, through: :customer_allergies, autosave: true
  has_many :reactions

  default_scope -> {order('id DESC')}
end
