class Customers::FamilyMedicalHistoriesController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path
  add_breadcrumb 'Profile', :customers_profile_path
  add_breadcrumb 'Family Medical History'

  def index
    @customer_profile_page = true

    @customer = session[:current_online_customer]
    @family_medical_histories = @customer.family_medical_histories
    @medical_conditions = MedicalCondition.all
  end

  def create
    @customer = session[:current_online_customer]
    @family_medical_history = @customer.family_medical_histories.create(family_medical_history_params)
    @insertion_status=insert_family_medical_history(@family_medical_history,params['chk-family_medicals'])
    @medical_conditions = MedicalCondition.all
    if @family_medical_history and @insertion_status
      render partial: 'new_family_medical_history'
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    @customer = session[:current_online_customer]
    @family_medical_history = @customer.family_medical_histories.find(params[:id])
    @family_medical_history.update(family_medical_history_params)
    @update_status=update_family_medical_history(@family_medical_history,params['chk-family_medicals'])
    @medical_conditions = MedicalCondition.all
    if @family_medical_history.save! and @update_status
      render :js => "window.location = '/customers/family_medical_histories'"
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @customer = session[:current_online_customer]
    @family_medical_history = @customer.family_medical_histories.find(params[:id])
    if @family_medical_history.destroy
      render json: { success: 'success' }, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  protected
  def family_medical_history_params
    params.require(:family_medical_history).permit(:name, :relation, :age, :status)
  end

  def insert_family_medical_history (family_history,medical_conditions)
    if medical_conditions.nil?
      return true
    end
    begin
      medical_conditions.each do |medical|
        FamilyMedicalCondition.create(family_medical_history_id:family_history.id, medical_condition_id:medical)
      end
    rescue
      return false
    end
    return true
  end

  def update_family_medical_history (family_history,medical_conditions)
    begin
      @family_member_medical_conditions=family_history.medical_conditions
      @checked_medical_conditions=MedicalCondition.where({id:medical_conditions})
      medical_conditions_to_be_removed=@family_member_medical_conditions-@checked_medical_conditions
      medical_conditions_to_be_added=@checked_medical_conditions-@family_member_medical_conditions

      medical_conditions_to_be_removed.each do |medical_condition|
        FamilyMedicalCondition.destroy_all(family_medical_history_id: family_history.id,medical_condition_id: medical_condition.id)
      end

      medical_conditions_to_be_added.each do |medical_condition|
        FamilyMedicalCondition.create(family_medical_history_id:family_history.id,medical_condition_id:medical_condition.id)
      end
    rescue
      return false
    end
    return true
  end
end
