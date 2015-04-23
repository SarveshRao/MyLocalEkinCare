class Customers::PackageDetailsController < CustomerAppController

  def create
    @customer_packages_page = true
    appointment_body = params[:body]
    appointment_dental = params[:dental]
    appointment_vision = params[:vision]
    provider_dental = params[:dental_id]
    provider_vision = params[:vision_id]
    provider_body = "At Home"
    txnid = params[:txnid]
    customer_id = params[:customer_id]
    package_id = params[:package_id]
    amount = params[:amount]

    @package_details = PackageDetail.new(appointment_body: appointment_body, appointment_dental: appointment_dental, appointment_vision: appointment_vision,
                                         provider_dental: provider_dental, provider_vision: provider_vision, provider_body: provider_body,
                                         txnid: txnid, customer_id: customer_id, package_id: package_id, amount: amount)

    @package_details.save!
  end
end