class Staff::HealthAssessments::LabResultsController < StaffController
  def create
    lab_tests = LabTest.all
    test_component = TestComponent.find(params[:component_id])
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    lab_result = health_assessment.lab_results.create(test_component_id: test_component.id, result: params[:test_result])
    lab_test = test_component.lab_test
    lab_test_components = lab_test.test_components
    range_value = params[:lab_result][:standard][:range_value].join(",")+","
    customer = health_assessment.customer
    gender = customer.gender.chars.first rescue 'M'
    # enterprise = Enterprise.find(health_assessment.enterprise_id)
    range = StandardRange.find_by(test_component_id: test_component.id, gender: gender)
    range.update(range_value: range_value)
    range.save
    standard_range = test_component.standard_range health_assessment
    # enterprise_all = Enterprise.all

    render json: {range: range, lab_result: lab_result, test_component: test_component, lab_test: lab_test, lab_tests: lab_tests, lab_test_components: lab_test_components, standard_range: standard_range}
  end

  def show
    lab_tests = LabTest.all
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    lab_result = health_assessment.lab_results.find(params[:id])
    test_component = lab_result.test_component
    lab_test = test_component.lab_test
    lab_test_components = lab_test.test_components
    standard_range = test_component.standard_range health_assessment
    customer = health_assessment.customer
    gender = customer.gender.chars.first rescue 'M'
    #enterprise = Enterprise.find(health_assessment.enterprise_id)
    range = StandardRange.find_by(test_component_id: test_component.id, gender: gender)
    # enterprise_all = Enterprise.all

    render json: {range: range, lab_result: lab_result, test_component: test_component, lab_test: lab_test, lab_tests: lab_tests, lab_test_components: lab_test_components, standard_range: standard_range}
  end

  def update
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    lab_result = health_assessment.lab_results.find(params[:id])
    lab_result.update(test_component_id: params[:test_component_id], result: params[:test_result])
    lab_result.save
    test_component = lab_result.test_component
    lab_test = test_component.lab_test
    # enterprise = Enterprise.find(health_assessment.enterprise_id)
    customer = health_assessment.customer
    gender = customer.gender.chars.first rescue 'M'
    range = StandardRange.find_by(test_component_id: test_component.id, gender: gender)
    if params[:normal] != nil
      range_value = params[:below_severe]+", "+params[:normal]+", "+params[:border]+", "+params[:severe]+","
    else
      range_value = params[:lab_result][:standard][:range_value].join(",")+","
    end
    range.update(range_value: range_value)
    range.save
    standard_range = test_component.standard_range health_assessment

    render json: {lab_result: lab_result, test_component: test_component, lab_test: lab_test, standard_range: standard_range}
  end

  def destroy
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    lab_result = health_assessment.lab_results.find(params[:id])
    lab_result.delete

    render json: {}, status: 200
  end
end
