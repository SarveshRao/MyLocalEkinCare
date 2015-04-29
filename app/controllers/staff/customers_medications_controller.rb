class Staff::CustomersMedicationsController < StaffController
  include ApplicationHelper

  def create
    @customer = Customer.find(params[:customer_id])
    @medication = @customer.medications.create(medication_params)
      #m.drug_id = params[:medication][:drug][:id]
      # m.provider_id = params[:medication][:provider][:id]

    @drug_id = @medication.drug.id rescue '-'
    # @provider_id = @medication.provider.id rescue '-'
    parsed_date = formatted_date @medication.date
    drug_name = @medication.drug.name rescue '-'
    date = numeric_date_format @medication.date
    # provider_name = @medication.provider.name rescue '-'

    render json: { medication: @medication, drugs: Drug.all, providers: Provider.all, drug_id: @drug_id, provider_id: @provider_id, customer_id: @customer.id, parsed_date: parsed_date, drug_name: drug_name, date: date}
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @medication = @customer.medications.find(params[:id])
    @medication.update(medication_params)
    #@medication.drug_id = params[:medication][:drug][:id]
    # @medication.provider_id = params[:medication][:provider][:id]
    @medication.save

    @drug_id = @medication.drug.id rescue '-'
    # @provider_id = @medication.provider.id rescue '-'
    parsed_date = formatted_date @medication.date
    drug_name = @medication.drug.name rescue '-'

    render json: { drugs: Drug.all, medication: @medication, drug_id: @drug_id, provider_id: @provider_id, customer_id: @customer.id, parsed_date: parsed_date, drug_name: drug_name }
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    @medication = @customer.medications.find(params[:id])
    if @medication.destroy
      render json: { success: 'success' }, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  protected
  def medication_params
    params.require(:medication).permit(:name, :medication_type, :date, :dose_quantity, :rate_quantity, :active, :prescriber_name)
  end
end
