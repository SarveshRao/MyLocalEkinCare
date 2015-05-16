class Immunization < ActiveRecord::Base
  has_many :customer_immunizations
  has_many :customers, through: :customer_immunizations, autosave: true

  default_scope -> {order('id DESC')}
end
