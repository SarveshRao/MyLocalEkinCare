class Customers::MedicationsController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Profile', :customers_profile_path
  add_breadcrumb 'Medications'
  #before_action :accessed_to_dashboard, only: :index

  def index
    @customer_profile_page = true
    customer_id = session[:current_online_customer].id
    @customer = Customer.find(customer_id)
    @medications = @customer.medications
  end

  def create
    @customer = session[:current_online_customer]
    @medication = @customer.medications.create(medication_params)

    if @medication
      render partial: 'new_medication'
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    @customer = session[:current_online_customer]
    @medication = @customer.medications.find(params[:id])
    @medication.update_attributes(medication_params)
    if @medication.save
      render partial: 'updated_medication'
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @customer = session[:current_online_customer]
    @medication = @customer.medications.find(params[:id])
    if @medication.destroy
      render json: { success: 'success' }, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  protected
  def medication_params
    params.require(:medication).permit(:medication_type, :name, :date, :dose_quantity, :rate_quantity, :instructions, :active, :prescriber_name)
  end

end
