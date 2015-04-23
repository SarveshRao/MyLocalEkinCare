class LandingController < ApplicationController
  before_filter :set_customer

  def ad1
  end

  def ad2
  end

  def thankyou
  end

  def set_customer
    @customer = Customer.new
  end
end
