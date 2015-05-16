class Customers::TimeLineController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Timeline'
  #before_action :accessed_to_dashboard

  def show
    @customer_time_line = true
  end
end
