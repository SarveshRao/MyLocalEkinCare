class Staff::HealthAssessments::TestComponentsController < StaffController
  def index
    lab_test = LabTest.find(params[:lab_test_id])
    test_components = lab_test.test_components
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    customer = health_assessment.customer
    gender = customer.gender.chars.first rescue 'M'
    age = customer.age['year']

    render json: {test_components: test_components.as_json(include: [:standard_ranges]), gender: gender, age: age}
  end

  def getTestComponents

    unless (params['lab_test_id'].nil?)
      @test_components_temp = TestComponent.search_lab_test(params['lab_test_id'], params[:sSearch])
    else
      @test_components_temp = TestComponent.search(params[:sSearch])
    end
    @test_component = @test_components_temp.page((params[:iDisplayStart].to_i/params[:iDisplayLength].to_i) + 1).per(params[:iDisplayLength])
    test_component_json = JSON.parse(@test_component.to_json())
    test_component_json.each do |test_component|
      range_array = test_component['range_value'].split(',')
      test_component['range_value1'] = range_array[0]
      test_component['range_value2'] = range_array[1]
      test_component['range_value3'] = range_array[2]
      test_component['range_value4'] = range_array[3]
    end
    render json: { aaData: test_component_json, iTotalRecords: LabTest.count * TestComponent.count, iTotalDisplayRecords: @test_components_temp.count(column_name='id') }
  end

  def updateStandardRange
    standard_range = StandardRange.find(params[:id])
    if(params['columnPosition'] == "0")
      @test_component = TestComponent.find(standard_range.test_component_id)
      @test_component.update(name: params['value'])
    elsif(params['columnPosition'] == "1")
      @test_component = TestComponent.find(standard_range.test_component_id)
      @test_component.update(lonic_code: params['value'])
    elsif(params['columnPosition'] == "2")
      @test_component = TestComponent.find(standard_range.test_component_id)
      @test_component.update(info: params['value'])
    else
      temp_standard_range_array = standard_range.range_value.split(',')
      #here we are mapping the position of view table column position to database table column position
      temp_standard_range_array[params['columnPosition'].to_i - 4] = params['value']
      temp_standard_range_array[temp_standard_range_array.length] = ''
      range_value = temp_standard_range_array.join(',')
      standard_range.update(range_value: range_value)
    end
    render json: {status: 200}
  end

  def addTestComponent
    enterprise_id = params['enterprise_id']
    test_component_lab_test_id = params['lab_test_id']
    test_component_name = params['test_component_name']
    test_component_lonic_code = params['test_component_lonic_code']
    test_component_unit = params['test_component_unit']
    temp_standard_range_value1_array = [params['range_value1'],params['range_value2'],params['range_value3'],params['range_value4'],'']
    temp_standard_range_value2_array = [params['range_value5'],params['range_value6'],params['range_value7'],params['range_value8'],'']
    test_component_info = params['test_component_info']
    @insertion_row_tc=insert_test_component(test_component_lab_test_id, test_component_name, test_component_unit, test_component_info, enterprise_id, test_component_lonic_code)
    @insertion_row_sr=insert_standard_range(@insertion_row_tc.id, 'M', temp_standard_range_value1_array.join(','), enterprise_id)
    @insertion_row_sr=insert_standard_range(@insertion_row_tc.id, 'F', temp_standard_range_value2_array.join(','), enterprise_id)
    render json: {status: 200}
  end

  def deleteStandardRange
    standard_range = StandardRange.find(params[:id])
    if(StandardRange.where(test_component_id: standard_range.test_component_id).count() == 1)
      test_component = TestComponent.find(standard_range.test_component_id)
      standard_range.delete()
      test_component.delete()
    end
    standard_range.delete()
    render json: {status: 200}
  end

  protected
  def insert_test_component (test_component_lab_test_id, test_component_name, test_component_unit, test_component_info, enterprise_id, test_component_lonic_code)
    inserted_row_id = -1
    begin
      if(test_component_unit == '')
        inserted_row_id = TestComponent.create(lab_test_id: test_component_lab_test_id, name:test_component_name, info: test_component_info, enterprise_id: enterprise_id, lonic_code: test_component_lonic_code)
      else
        inserted_row_id = TestComponent.create(lab_test_id: test_component_lab_test_id, name:test_component_name, units:test_component_unit, info: test_component_info, enterprise_id: enterprise_id, lonic_code: test_component_lonic_code)
      end
    end
    return inserted_row_id
  end

  def insert_standard_range (test_component_id, standard_range_gender, standard_range_value, enterprise_id)
    begin
      StandardRange.create(test_component_id: test_component_id, gender:standard_range_gender, range_value:standard_range_value, enterprise_id: enterprise_id)
    end
    return true
  end
end
