class Staff::HealthAssessments::RecommendationsController < StaffController
  def index
  end

  def create
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    @recommendation = @health_assessment.recommendations.create(
    title: params[:recommendation][:title],
    description: params[:recommendation][:description]
    )
    if @recommendation
      render partial: 'new_recommendation'
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    if @recommendation.update(recommendation_params)
      render partial: 'updated_recommendation'
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def destroy
    recommendation = Recommendation.find(params[:id])
    if recommendation.destroy
      render json: {msg: 'success'}, status: 200
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  protected
  def recommendation_params
    params.require(:recommendation).permit(:title, :description, :recommend_id, :recommend_type)
  end
end
