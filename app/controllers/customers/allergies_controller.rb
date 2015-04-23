class Customers::AllergiesController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Profile', :customers_profile_path
  add_breadcrumb 'Allergies'
  #before_action :accessed_to_dashboard, only: :index

  def index
    @customer_profile_page = true

    customer_id = current_online_customer.id
    @customer = Customer.find(customer_id)
    @allergies = @customer.allergies
  end

  def create
    @customer = current_online_customer
    @allergy = @customer.allergies.create(name: params[:allergy][:name], reaction: params[:allergy][:reaction])
    @customer_allergy = @allergy.customer_allergies.first
    @customer_allergy.update(severity: params[:allergy][:customer_allergies][:severity])
    if @customer_allergy.save
      render partial: 'new_allergy'
    else
      render json: {}, status: :unprocessable_entity
    end

  end

  def update
    @customer = current_online_customer
    @customer_allergy = @customer.customer_allergies.find(params[:id])
    @allergy = Allergy.find(@customer_allergy.allergy_id)
    @customer_allergy.severity = params[:allergy][:customer_allergies][:severity]
    @allergy.name = params[:allergy][:name]
    @allergy.reaction = params[:allergy][:reaction]
    if @customer_allergy.save! && @allergy.save!
      render partial: 'updated_allergy'
    else
      render json: {}, status: :unprocessable_entity
    end

  end

  def destroy
    @customer = current_online_customer
    customer_allergy = @customer.customer_allergies.find(params[:id])
    allergy = Allergy.find(customer_allergy.allergy_id)
    if allergy.destroy && customer_allergy.destroy
      render json: {success: 'success'}, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def show
    @allergy = Allergy.find(params[:id])
    render json: {allergy: @allergy}
  end

  protected
  def allergy_params
    params.require(:allergy).permit(:name, :reaction, customer_allergies_attributes: [:severity, :allergy_id])
  end

end
