class HomeController < ApplicationController
  def index
    if online_customer_signed_in?
      redirect_to customers_dashboard_path
    end
    @customer = Customer.new
  end

  def faq
  end

  def about_us
  end

  def contact_us
  end

  def terms_and_conditions
  end
end