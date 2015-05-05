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
        raw_xml = "<Contacts><row no='1'><FL val='Phone'>"+ @customer.customer_id + "</FL><FL val='Last Activity Time'>" + Time.now().to_s() + "</FL><FL val='Last Name'>" + @customer.last_name + "</FL></row></Contacts>"
        encoded_xml = CGI::escape(raw_xml)
        uri = URI.parse('https://crm.zoho.com/crm/private/json/Contacts/insertRecords?authtoken=460110734aed45ea412ab6637dd4cbf8&xmlData='+encoded_xml)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        post_request = Net::HTTP::Post.new(uri, {'Content-Type' =>'text/xml'})
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
