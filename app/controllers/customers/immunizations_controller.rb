class Customers::ImmunizationsController < CustomerAppController
  include ApplicationHelper
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Profile', :customers_profile_path
  add_breadcrumb 'Immunizations'
  #before_action :accessed_to_dashboard, only: :index


  def new

  end

  def create
    customer_id = session[:current_online_customer].id
    @customer = Customer.find(customer_id)
    @immunization = Immunization.create!(immunization_params)

    @customer_immunization = @customer.customer_immunizations.create!(
        dosage: params[:immunization][:customer_immunizations][:dosage],
        date: params[:immunization][:customer_immunizations][:date],
        instructions: params[:immunization][:customer_immunizations][:instructions]
    )

    @customer_immunization.update(immunization: @immunization)
    if @customer_immunization.save!
      render partial: 'new_immunization'
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def index
    @customer_profile_page = true

    customer_id = session[:current_online_customer].id
    @customer = Customer.find(customer_id)
    @immunizations = @customer.immunizations
  end

  def update
    @customer = session[:current_online_customer]
    @immunization = Immunization.find(params[:id])
    @immunization.update(immunization_params)
    @customer_immunization = @customer.customer_immunizations.find_by(immunization_id: @immunization.id)
    @customer_immunization.date = params[:immunization][:customer_immunizations][:date]
    @customer_immunization.dosage = params[:immunization][:customer_immunizations][:dosage]
    @customer_immunization.instructions = params[:immunization][:customer_immunizations][:instructions]

    if @customer_immunization.save
      render partial: 'updated_immunization'
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @customer = session[:current_online_customer]
    @immunization = @customer.immunizations.find(params[:id])
    customer_immunization = @customer.customer_immunizations.find_by(immunization_id: @immunization.id)

    if customer_immunization.destroy && @immunization.destroy
      render json: {success: 'success'}, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end

  end

  protected
  def immunization_params
    params.require(:immunization).permit(:name, :immunization_type, customer_immunizations_attributes: [:dosage, :date, :instructions])
  end

end
