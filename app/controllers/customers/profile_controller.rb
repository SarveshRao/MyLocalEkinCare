class Customers::ProfileController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Profile'
  #before_action :accessed_to_dashboard, only: :show

  def show
    @customer_profile_page = true
     @customer = session[:current_online_customer]
  end

  def update
    if params[:customer][:general_issues].present?
      params[:customer][:general_issues] = params[:customer][:general_issues].reject!{|gi| gi == "" }.join(',').to_s rescue ''
      params[:customer][:other_body_parts] = params[:customer][:other_body_parts].join(',').to_s rescue ''
    end

    if params[:customer][:daily_activity]
      #@life_style = true
      session[:life_style] = true
      session[:bio] = false
      session[:contact] = false
      session[:current_complaints] = false
    elsif params[:customer][:date_of_birth]
      session[:bio] = true
      session[:life_style] = false
      session[:contact] = false
      session[:current_complaints] = false
      #@bio = true
    elsif params[:customer][:mobile_number]
      #@contact = true
      session[:contact] = true
      session[:life_style] = false
      session[:bio] = false
      session[:current_complaints] = false
    elsif params[:customer][:general_issues]
      session[:current_complaints] = true
      session[:contact] = false
      session[:life_style] = false
      session[:bio] = false
    end

    customer_id = session[:current_online_customer].id
    @customer = Customer.find(customer_id)
    @customer.update(customer_params)

    if params[:customer][:weight] || params[:customer][:feet] || params[:customer][:inches] || params[:blood_group_id]
      customer_vitals = CustomerVitals.find_by("customer_id='#{customer_id.to_s}'")
      customer_vitals.update(customer_id: customer_id, weight: params[:customer][:weight],feet: params[:customer][:feet],inches: params[:customer][:inches],blood_group_id: params[:blood_group_id])
    end
    if @customer.save
      # flash.now[:notice] = "Profile has been updated successfully!"
      if session[:bio] == true
        render partial: 'normal_bio_details', notice:"Profile has been updated successfully!"
      elsif session[:life_style] == true
        render partial: 'normal_life_style_details', notice:"Profile has been updated successfully!"
      elsif session[:contact] == true
        render partial: 'normal_contact_details', notice:"Profile has been updated successfully!"
      elsif session[:current_complaints] == true
        render partial: 'normal_current_complaints_details', notice:"Profile has been updated successfully!"
      end
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def upload_avatar
    begin
      @customer = session[:current_online_customer]
      @customer.image = params[:file]
      if @customer.save!
        respond_to do |format|
          format.js
        end
      end
    rescue ActiveRecord::RecordInvalid
      #render json: {msg: 'error'}, status: 422
      respond_to do |format|
        raise '422'
        #format.js{render 'customers/profile/invalid_record.js.erb'}
      end
    end
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :date_of_birth, :image, :daily_activity, :frequency_of_exercise,
                                     :gender, :martial_status, :language_spoken, :ethnicity, :smoke, :alcohol, :medical_insurance, :customer_type, :diet,
                                     :religious_affiliation, :mobile_number, :alternative_mobile_number, :number_of_children,
                                     :general_issues, :other_body_parts,
                                     addresses_attributes: [:line1, :line2, :city, :state, :country, :id, :zip_code],
                                     customer_vitals_attributes: [:weight, :feet, :inches, :blood_group_id]
    )
  end
end
