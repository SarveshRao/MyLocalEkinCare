class Customers::AfterSignupController < CustomerAppController
  include Wicked::Wizard
  respond_to :html, :xml, :json
  respond_to :js, :only => :upload_documents
 
  layout 'wizard'
  #before_action :accessed_to_dashboard, only: :show
  steps :your_health, :upload_documents, :thank_you_page

  def show
    @customer = current_online_customer
    case step
      when :your_health
        @address = @customer.addresses.first || Address.new
        @customer_vitals = @customer.customer_vitals || CustomerVitals.new
        @medical_histories = @customer.family_medical_histories
        @father_medical_history = @medical_histories.find_by(relation: 'Father') || FamilyMedicalHistory.new
        @mother_medical_history = @medical_histories.find_by(relation: 'Mother') || FamilyMedicalHistory.new
        @sibling_medical_history = @medical_histories.find_by(relation: 'Sibling') || FamilyMedicalHistory.new
        @zip_code = @address.zip_code
        @weight = @customer_vitals.weight
      when :upload_documents
      when :thank_you_page
    end

    @customer.status = step
    @customer.save

    render_wizard
  end

  def update
    @customer = current_online_customer

    @customer.update(customer_params)

    if @customer.family_medical_histories.empty?
      create_medical_histories
    else
      update_medical_histories
    end

    if @customer.addresses.empty?
      @customer.addresses.create(zip_code: params[:zip])
    else
      address = @customer.addresses.first
      address.zip_code = params[:zip]
      address.save
    end

    if @customer.customer_vitals.nil?
      CustomerVitals.create(weight: params[:customer][:weight], feet: params[:customer][:feet], inches: params[:customer][:inches], blood_group_id: params[:customer][:blood_group_id],customer: @customer)
    else
      #updating vitals
      vital=Vital.find_by_customer_id(@customer.id)
      customer_vitals = CustomerVitals.find_by_customer_id(@customer.id.to_s)

      weight_id=VitalList.find_by_name('weight').id

      customer_vitals.weight = params[:customer][:weight]
      customer_vitals.feet = params[:customer][:feet]
      customer_vitals.inches = params[:customer][:inches]
      customer_vitals.blood_group_id = params[:customer][:blood_group_id]
      customer_vitals.save

      customer_id=@customer.id
      weight_id=VitalList.find_by_name('weight').id
      height_id=VitalList.find_by_name('feet').id
      inches_id=VitalList.find_by_name('inches').id
      if(params[:customer][:weight].present?)
        vital=Vital.new
        vital.customer_id=customer_id
        vital.vital_list_id=weight_id
        vital.value=params[:customer][:weight]
        vital.save
      end

      if(params[:customer][:feet].present?)
        vital=Vital.new
        vital.customer_id=customer_id
        vital.vital_list_id=height_id
        vital.value=params[:customer][:feet]
        vital.save
      end

      if(params[:customer][:inches].present?)
        vital=Vital.new
        vital.customer_id=customer_id
        vital.vital_list_id=inches_id
        vital.value=params[:customer][:inches]
        vital.save
      end
    end

    @customer.status = next_step

    @customer.save!
    sign_in(@customer, bypass: true) # needed for devise
    render_wizard @customer
  end

  def upload_documents
    @customer = current_online_customer

    begin
      params[:files].each do |file|
        @medical_record = @customer.medical_records.build(emr: file)
        @medical_record.save!
      end

    rescue ActiveRecord::RecordInvalid
      raise 422
    end
  end

  protected
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :date_of_birth, :daily_activity, :frequency_of_exercise, :status,
                                     :gender, :martial_status, :language_spoken, :ethnicity, :smoke, :alcohol, :medical_insurance, :customer_type, :diet,
                                     :religious_affiliation, :mobile_number, :alternative_mobile_number, :number_of_children,:general_issues, :other_body_parts,
                                     customer_vitals_attributes: [:weight, :feet, :inches, :blood_group_id],
                                     family_medical_histories_attributes: [:relation, :medical_condition_1, :medical_condition_2, :medical_condition_3, :status],
                                     addresses_attributes: [:line1, :city, :state, :country, :id, :zip_code])

  end

  def customer_vitals_params
    params.require(:customer).permit(customer_vitals_attributes: [:weight, :blood_group_id, :feet, :inches, :customer_id])
  end

  def medical_history_params
    params.require(:customer).permit(family_medical_histories_attributes: [:relation, :medical_condition_1, :medical_condition_2, :medical_condition_3, :status])
  end

  def create_medical_histories
    FamilyMedicalHistory.create(relation: 'Father', status: params[:father], medical_condition_1: params['chk-father'].to_s, customer: @customer)
    FamilyMedicalHistory.create(relation: 'Mother', status: params[:mother], medical_condition_1: params['chk-mother'].to_s, customer: @customer)
    FamilyMedicalHistory.create(relation: 'Sibling', status: params[:sibling], medical_condition_1: params['chk-sibling'].to_s, customer: @customer)
  end

  def update_medical_histories
    @customer.family_medical_histories.each do |medical_history|
      if medical_history.is_father?
        medical_history.status = params[:father]
        medical_history.medical_condition_1 = params['chk-father'].to_s
      elsif medical_history.is_mother?
        medical_history.status = params[:mother]
        medical_history.medical_condition_1 = params['chk-mother'].to_s
      else
        medical_history.status = params[:sibling]
        medical_history.medical_condition_1 = params['chk-sibling'].to_s
      end
      medical_history.save
    end
  end
end
