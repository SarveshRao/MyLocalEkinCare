class Staff::HealthAssessments::NotesController < StaffController
  include ApplicationHelper

  def index
  end

  def show
  end

  def create
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    @notes = @health_assessment.notes
    @notes.create(title: params[:note][:title], description: params[:note][:description], staff_id: current_staff.id)

    render partial: 'index'
  end

  def destroy
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    @note = @health_assessment.notes.find(params[:id])
    @note.delete
    render json: 'success', status: 200
  end
end
