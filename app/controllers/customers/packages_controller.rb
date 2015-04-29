class Customers::PackagesController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Packages'

  def index
    @customer_packages_page = true
    @packages = ProviderTest.joins("inner join enterprises on enterprises.id = provider_tests.provider_id where enterprise_id='EK' order by provider_tests.name")
  end

  def learnmore

    @customer_packages_page = true
    @package = ProviderTest.find_by("id=?",params[:package])
    package = @package.name.split(" ")
    if package.count > 2
      render "customers/packages/learnmore_#{package[0].downcase}_#{package[1].downcase}_#{package[2].downcase}"
    else
      render "customers/packages/learnmore_#{package[0].downcase}"
    end
  end
end