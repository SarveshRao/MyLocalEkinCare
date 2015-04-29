class CustomerProcedure < ActiveRecord::Base
  belongs_to :customer_id
  belongs_to :procedure_id
end
