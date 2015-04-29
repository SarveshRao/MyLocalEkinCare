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
        # Adding the post call after successful upload starts here
        uri = URI('https://crm.zoho.com/crm/private/json/Leads/insertRecords')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        params =
            {
                'authtoken' => '460110734aed45ea412ab6637dd4cbf8',
                'xmlData' => CGI.escape("<Contacts><row no='1'><FL val='Phone'>" + @customer.mobile_number + "</FL><FL val='Last Activity Time'>" + Time.now().to_s() + "</FL></row></Contacts>")
            }
        post_request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'text/xml'})
        post_request.body = URI.encode_www_form(params)
        response = http.request(post_request)
        # Adding the post call after successful upload ends here
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
