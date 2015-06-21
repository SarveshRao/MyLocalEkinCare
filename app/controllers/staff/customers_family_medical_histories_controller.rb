class Staff::CustomersFamilyMedicalHistoriesController < StaffController
  include ApplicationHelper

  def new
  end

  def index
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @family_medical_history = @customer.family_medical_histories.create(family_medical_history_params)
    @insert_status=insert_family_medical_history(@family_medical_history,params['chk-family_medicals'])
    @family_medical_history = @customer.family_medical_histories.find(@family_medical_history.id)
    @medical_conditions = MedicalCondition.all
    render json: { family_medical_history: @family_medical_history, customer_id: @customer.id ,checked_values: @family_medical_history.medical_conditions.map { |r| r.name }}
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @family_medical_history = @customer.family_medical_histories.find(params[:id])
    @family_medical_history.update(family_medical_history_params)
    update_family_medical_history(@family_medical_history,params['chk-family_medicals'])
    @family_medical_history.save
    @medical_conditions = MedicalCondition.all
    @family_medical_history = @customer.family_medical_histories.find(params[:id])
    render json: { family_medical_history: @family_medical_history, customer_id: @customer.id,checked_values: @family_medical_history.medical_conditions.map { |r| r.name }}
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
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
    if medical_conditions.nil? or medical_conditions=='0'
      return true
    end
    begin
      medical_conditions.each do |medical|
        # medical_condition=MedicalCondition.find_by_name(medical)
        FamilyMedicalCondition.create(family_medical_history_id:family_history.id,medical_condition_id:medical) rescue '-'
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
