class Staff::HealthAssessments::LabTestsController < StaffController
  def index
    @lab_tests = LabTest.where(enterprise_id: params[:enterprise_id])
    @lab_test_names = @lab_tests.collect{|lt| {id: lt.id, name: lt.name, info: lt.info}}

    respond_to do |format|
      format.json{render json: @lab_test_names}
    end
  end

  def getLabTests
    @lab_tests_temp = LabTest.search(params[:enterprise_id], params[:sSearch])
    @lab_tests = @lab_tests_temp.page((params[:iDisplayStart].to_i/params[:iDisplayLength].to_i) + 1).per(params[:iDisplayLength])
    render json: { aaData: JSON.parse(@lab_tests.to_json()), iTotalRecords: LabTest.count * TestComponent.count, iTotalDisplayRecords: @lab_tests_temp.size}
  end

  def updateLabTest
    @lab_test = LabTest.find(params[:id])
    if(params['columnPosition'] == "0")
      @lab_test.update(name: params['value'])
    elsif(params['columnPosition'] == "1")
      @lab_test.update(info: params['value'])
    end
    render json: {status: 200}
  end

  def addLabTest
    enterprise_id = params['enterprise_id']
    lab_test_name = params['lab_test_name']
    lab_test_info = params['lab_test_info']
    inserted_row_id = LabTest.create(enterprise_id: enterprise_id, name: lab_test_name, info: lab_test_info)
    if inserted_row_id.id > 0
      render json: {status: 200}
    else
      render json: {status: 500}
    end
  end

  def deleteLabTest
    lab_test_id = params['id']
    @test_components_ids = TestComponent.where(lab_test_id: lab_test_id).pluck(:id)
      @standard_range_ids = StandardRange.where(test_component_id: @test_components_ids).pluck(:id)
        StandardRange.delete(@standard_range_ids)
      TestComponent.delete(@test_components_ids)
    LabTest.delete(lab_test_id)
    render json: {status: 200}
  end

end
