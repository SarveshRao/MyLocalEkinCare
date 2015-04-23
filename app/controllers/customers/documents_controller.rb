class Customers::DocumentsController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Documents'

  def index
    @customer_documents_page = true
  end

  def create
    @customer = Customer.find(params[:customer_id])
    params[:files].each do |file|
      @medical_record = @customer.medical_records.build(emr: file, date: Time.now())
      if @medical_record.save!
        url = request.protocol + request.host_with_port
        Notification.customer_uploaded_documents(@customer.customer_id, url).deliver!
        render :js => "window.location = '/customers/documents'"
      end
    end
  end

  def delete
    @medical_record = MedicalRecord.find(params[:id])
    @medical_record.remove_emr!
    @medical_record.destroy

    render text: 'ok', status: 200
  end
end
