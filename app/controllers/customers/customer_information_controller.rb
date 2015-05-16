class Customers::CustomerInformationController < ApplicationController
  include ApplicationHelper

  def show
    unless current_online_customer.nil?
      @customer=current_online_customer
      @customer_vitals=@customer.customer_vitals
      @systolic_blood_pressure=@customer.systolic[:result]
      @diastolic_blood_pressure=@customer.diastolic[:result]

      @blood_pressure_value=false
      if(@systolic_blood_pressure!='-' and @diastolic_blood_pressure!='-')
        @blood_pressure_value=true
      end
      @mother_health_status=@customer.mother_has_health_history?
      @father_health_status=@customer.father_has_health_history?

      respond_to do |format|
        format.json {render :json => { weight:@customer_vitals.weight,feet:@customer_vitals.feet,inches:@customer_vitals.inches,waist:@customer_vitals.waist,bmi:@customer.bmi,
                            smoke:@customer.smoke,alcohol:@customer.alcohol,exercise:@customer.frequency_of_exercise,blood_sugar:@customer.assessment_body_sugar,
                            blood_pressure:@blood_pressure_value,blood_group:@customer_vitals.blood_group_id.nil?,mother_health:@mother_health_status,father_health:@father_health_status}}
      end
    else
      respond_to do |format|
        format.json {render :json => {}}
      end
    end
  end

  def update
    @customer=current_online_customer
    @modified_date=formatted_date Time.now
    respond_to do |format|
      if(@customer.update_attributes(customer_params))
        format.json {render :json => { bmi:@customer.bmi,bmi_color:@customer.colored_bmi,updated_at:@modified_date,:status => 200 }}
      else
        render json: {}, status: :unprocessable_entity
      end
    end
  end

  def update_customer_vitals
    @customer=current_online_customer
    @customer_vitals=@customer.customer_vitals
    @modified_on=formatted_date Time.now

    respond_to do |format|
      if(@customer_vitals.update(customer_vitals_params))
        @customer.update(is_obese: @customer.obesity_overweight_checkup==4 ? "Obese" : "No", is_over_weight: @customer.obesity_overweight_checkup==3 ? "OverWeight" : "No")
        format.json {render :json => { bmi:@customer.bmi,bmi_color:@customer.colored_bmi,date:@modified_on,:status => 200 }}
      else
        render json: {}, status: :unprocessable_entity
      end
    end
  end

  def hypertension_prediction_values
    @customer=current_online_customer
    @hyper_tension_scores=Hash.new()
    [1,2,3,4].each do |year|
      @hyper_tension_score=@customer.hypertension_score(year).round(3)
      @hyper_tension_scores[year]=(@hyper_tension_score*100).round
    end
    respond_to do |format|
      format.json {render :json => {hypertension:@hyper_tension_scores,:status => 200 }}
    end
  end

  def lab_result_values
    test_component_name=params[:test_component_name]
    lonic_code = TestComponent.find_by_name(test_component_name).lonic_code
    if lonic_code
      test_component=TestComponent.find_by(lonic_code: lonic_code)
    else
      test_component=TestComponent.find_by_name(test_component_name)
    end
    customer=current_online_customer
    lab_result_values=test_component.test_component_values(customer)
    respond_to do |format|
      format.json {render :json => { values:lab_result_values}}
    end
  end

  def get_message_prompts
    @customer=current_online_customer
    @gender=@customer.gender
    @risk_factors=Hash.new
    RiskFactor.all.each do |risk_factor|
      @message_prompt=Hash.new
      risk_factor.message_prompts.where(gender: @gender).all.each do |message_prompt|
        @message_prompt[message_prompt.range + '_value']=message_prompt.message
        @message_prompt[message_prompt.range + '_image']=message_prompt.image
      end
      @risk_factors[risk_factor.Name]=@message_prompt
    end
    respond_to do |format|
      format.json {render :json => {message:@risk_factors,:status => 200 }}
    end
  end

  protected
  def customer_params
    params.require(:customer).permit(:daily_activity, :frequency_of_exercise, :smoke,:alcohol)
  end

  def customer_vitals_params
    params.require(:undefined).permit(:weight,:feet,:inches,:blood_group_id,:waist)
  end
end
