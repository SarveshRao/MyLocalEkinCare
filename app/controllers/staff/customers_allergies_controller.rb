class Staff::CustomersAllergiesController < StaffController
  def new
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @allergy = @customer.allergies.create(allergy_params)
    @customer_allergy = @customer.customer_allergies.first
    @customer_allergy.update(severity: params[:allergy][:customer_allergies][:severity])
    @customer_allergy.save
    @allergies = Allergy.all

    render json: {allergy: @allergy, customer_allergy: @customer_allergy, allergies: @allergies}
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @customer_allergy = @customer.customer_allergies.find(params[:id])
    @allergy = Allergy.find(@customer_allergy.allergy_id)
    @allergy.update_attributes(allergy_params)
    @customer_allergy.severity = params[:allergy][:customer_allergies][:severity]
    @customer_allergy.save!
    @allergy.save!

    render json: {customer_allergy: @customer_allergy, allergy: @allergy}
  end

  def index
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
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
