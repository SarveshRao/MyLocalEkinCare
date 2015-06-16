class CustomerAppController < ApplicationController
  before_filter :check_customer_signed_in
  layout 'customer'

  force_ssl if: :ssl_configured?

  def check_customer_signed_in
    unless online_customer_signed_in?
      redirect_to root_path
    end
  end

  def xeditable? object = nil
    xeditable = params[:denied] ? false : true
    can?(:edit, object) and xeditable ? true : false
  end
  helper_method :xeditable?

  def can? edit, model
    true
  end
  helper_method :can?

  protected
  def ssl_configured?
    Rails.env.production? && online_customer_signed_in?
  end

  #def accessed_to_dashboard
  #  unless session[:current_online_customer].status == 'wicked_finish'
  #    redirect_to customers_dashboard_path
  #  end
  #end
end
