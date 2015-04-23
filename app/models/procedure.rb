class Procedure < ActiveRecord::Base
  has_many :customer_procedures
  has_many :customers, through: :customer_procedures
end
