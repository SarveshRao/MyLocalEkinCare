class Staff::HealthAssessments::ResultsController < StaffController
  def create
    @dental_assessment = DentalAssessment.find(params[:health_assessment_id])
    @examination = @dental_assessment.examination
    @result = @examination.results.create(dentition: params[:result][:dentition], tooth_number: params[:result][:tooth_number], diagnosis: params[:result][:diagnosis],
                            recommendation: params[:result][:recommendation])

    render partial: 'new_result'
  end

  def show
    @dental_assessment = DentalAssessment.find(params[:health_assessment_id])
    @examination = @dental_assessment.examination.find(params[:id])

    render json: {examination: @examination}
  end

  def update
    @dental_assessment = DentalAssessment.find(params[:health_assessment_id])
    @result = @dental_assessment.examination.results.find(params[:id])
    @result.update result_params
    @result.save

    render partial: 'updated_result'
  end

  def destroy
    Result.find(params[:id]).delete

    render json: {status: 'success'}, status: 200
  end

  protected
  def result_params
    params.require(:result).permit(:dentition, :tooth_number, :diagnosis, :recommendation)
  end

end
