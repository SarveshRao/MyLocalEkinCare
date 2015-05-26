class Customers::CustomerLabResultsController < ApplicationController
  include ApplicationHelper
  def update
    systolic_value = params[:undefined][:blood_pressure][:systolic]
    diastolic_value=params[:undefined][:blood_pressure][:diastolic]
    @current_customer=current_online_customer
    @updated_date=formatted_date (Time.now)

    sys_code = TestComponent.find_by("lower(name)='systolic'").lonic_code
    dia_code = TestComponent.find_by("lower(name)='diastolic'").lonic_code
    if sys_code and dia_code
      @systolic_component_id=TestComponent.find_by(lonic_code: sys_code.to_s, enterprise_id: Enterprise.find_by_enterprise_id('EK').id).id
      @diastolic_component_id=TestComponent.find_by(lonic_code: dia_code.to_s, enterprise_id: Enterprise.find_by_enterprise_id('EK').id).id
    else
      @systolic_component_id=TestComponent.find_by(name: 'Systolic', enterprise_id: Enterprise.find_by_enterprise_id('EK').id).id
      @diastolic_component_id=TestComponent.find_by(name: 'Diastolic', enterprise_id: Enterprise.find_by_enterprise_id('EK').id).id
    end

    @new_health_assessment=@current_customer.health_assessments.create(request_date:Time.now,assessment_type:'Body',status:'done',type:'BodyAssessment',status_code:6, enterprise_id: Enterprise.find_by_enterprise_id('EK').id)
    @new_health_assessment.lab_results.create(test_component_id: @diastolic_component_id, result: diastolic_value)
    @new_health_assessment.lab_results.create(test_component_id: @systolic_component_id, result: systolic_value)

    @systolic_color=get_color(@systolic_component_id,systolic_value, @new_health_assessment.id)
    @diastolic_color=get_color(@diastolic_component_id,diastolic_value, @new_health_assessment.id)

    @hypertensive = @current_customer.has_hypertension
    @current_customer.update(is_hypertensive: @hypertensive ? "Hypertensive" : "No")

    respond_to do |format|
      format.json {render :json => {date:@updated_date, systolic_color:@systolic_color,diastolic_color: @diastolic_color,:status => 200 }}
    end
  end

  def update_blood_sugar
    @customer=current_online_customer
    @new_health_assessment=@customer.health_assessments.create(request_date:Time.now,assessment_type:'Body',status:'done',type:'BodyAssessment',status_code:6, enterprise_id: Enterprise.find_by_enterprise_id('EK').id)
    @blood_sugar_component_id=params[:test_component_id]
    result=params[:lab_result][:result]
    @updated_date=formatted_date (Time.now)
    @new_health_assessment.lab_results.create(test_component_id: @blood_sugar_component_id, result: result)
    @blood_sugar_color=get_color @blood_sugar_component_id,result, @new_health_assessment.id

    @diabetic = @customer.is_diabetic
    @customer.update(diabetic: @diabetic ? "Diabetic" : "No")

    respond_to do |format|
      format.json {render :json => {date:@updated_date, color:@blood_sugar_color ,name:'Fasting blood sugar',:status => 200 }}
    end
  end

  def get_color test_component_id,result, assessment_id
    result=result.to_i
    test_component_name=TestComponent.find(test_component_id).name
    return current_online_customer.resulted_component_value2(test_component_name, result, assessment_id)[:color]
  end
end
