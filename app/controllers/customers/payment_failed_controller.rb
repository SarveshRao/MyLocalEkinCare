class Customers::PaymentFailedController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Packages', :customers_packages_path
  add_breadcrumb 'Payment Failed'

  def index
    @customer_packages_page = true
    @key = params[:key]
    @txnid = params[:txnid]
    @amount = params[:amount]
    @status = params[:status]
    @mihpayid = params[:mihpayid]
    @mode = params[:mode]
    @discount = params[:discount]
    @hash = params[:hash]
    @error = params[:error_Message]
    @pg_type = params[:PG_TYPE]
    @bank_ref_num = params[:bank_ref_num]
    @unmappedstatus = params[:unmappedstatus]
    @payu_id = params[:payuMoneyId]
    @name = params[:firstname]
    @reduced_amount = @amount.to_f - @discount.to_f

    @customer = session[:current_online_customer]
    @package = PackageDetail.find_by_txnid(@txnid)
    @payment_details = PaymentDetail.new(txnid: @txnid, status: @status, amount: @amount, mihpayid: @mihpayid, mode: @mode, discount: @discount,
                                         checksum: @hash, error: @error, pg_type: @pg_type, bank_ref_num: @bank_ref_num, unmappedstatus: @unmappedstatus, payumoney_id: @payu_id, package_id: @package.id)
    @payment_details.save!
  end
end