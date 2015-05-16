class Staff::CustomersImmunizationsController < StaffController
  include ApplicationHelper

  def create
    @customer = Customer.find(params[:customer_id])
    @new_immunization = Immunization.create!(immunization_params)

    @customer_immunization = @customer.customer_immunizations.create!(
        dosage: params[:immunization][:customer_immunizations][:dosage],
        date: params[:immunization][:customer_immunizations][:date],
        instructions: params[:immunization][:customer_immunizations][:instructions]
    )

    @customer_immunization.update(immunization: @new_immunization)
    @customer_immunization.save!

    immunization_date = formatted_date @customer_immunization.date
    parsed_date = numeric_date_format @customer_immunization.date
    render json: {immunization: @new_immunization, customer_immunization: @customer_immunization, date: immunization_date, parsed_date: parsed_date}
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @immunization = Immunization.find(params[:id])
    @immunization.update immunization_params
    @customer_immunization = @customer.customer_immunizations.find_by(immunization_id: @immunization.id)
    @customer_immunization.date = params[:immunization][:customer_immunizations][:date]
    @customer_immunization.dosage = params[:immunization][:customer_immunizations][:dosage]
    @customer_immunization.instructions = params[:immunization][:customer_immunizations][:instructions]
    @customer_immunization.save

    immunization_date = formatted_date @customer_immunization.date
    render json: {immunization: @immunization, customer_immunization: @customer_immunization, date: immunization_date}
  end


  def index
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    immunization = @customer.immunizations.find(params[:id])
    immunization.destroy

    render json: {success: 'success'}, status: 200
  end

  protected
  def immunization_params
    params.require(:immunization).permit(:name, :immunization_type, customer_immunizations_attributes: [:dosage, :date, :instructions])
  end
end
