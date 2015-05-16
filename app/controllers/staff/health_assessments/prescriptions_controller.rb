class Staff::HealthAssessments::PrescriptionsController < StaffController

  def create
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    @customer = @health_assessment.customer

    lens_type = params[:lens_type].join(',') rescue '-'

    @prescription = @health_assessment.create_prescription(lens_type: lens_type)

    @left_correction = @prescription.corrections.create(
        eye: params[:eye][:left]
    )

    @right_correction = @prescription.corrections.create(
        eye: params[:eye][:right]
    )

   a =  @left_correction.create_vision_component(
        ucva: params[:ucva][:left],
        spherical: params[:spherical][:left],
        cylindrical: params[:cylindrical][:left],
        axis: params[:axis][:left],
        prism: params[:prism][:left],
        add: params[:add][:left],
        cva: params[:cva][:left],
        units: params[:units][:left],
        prism2: params[:prism2][:left],
        units2: params[:units2][:left]

    )
    b = @right_correction.create_vision_component(
        ucva: params[:ucva][:right],
        spherical: params[:spherical][:right],
        cylindrical: params[:cylindrical][:right],
        axis: params[:axis][:right],
        prism: params[:prism][:right],
        add: params[:add][:right],
        cva: params[:cva][:right],
        units: params[:units][:right],
        prism2: params[:prism2][:right],
        units2: params[:units2][:right]
    )

    redirection_url = "#{request.protocol}#{request.host}/customers/#{@customer.id}/health_assessments/#{@health_assessment.id}"
    if @prescription
      redirect_to redirection_url
    else
      render text: 'error', status: :unprocessable_entity
    end


  end

  def show
  end

  def update
    @health_assessment = HealthAssessment.find(params[:health_assessment_id])
    @customer = @health_assessment.customer
    @prescription = @health_assessment.prescription

    lens_type = params[:lens_type].join(',') rescue '-'

    @prescription.update_attributes(lens_type: lens_type)
    @left_correction = @prescription.corrections.find_by(eye: 'left')
    @right_correction = @prescription.corrections.find_by(eye: 'right')
    @left_correction_component = @left_correction.vision_component
    @right_correction_component = @right_correction.vision_component

    @left_correction.update(
        eye: params[:eye][:left]
    )

    @right_correction.update(
       eye: params[:eye][:right]
    )

    @left_correction_component.update(
        ucva: params[:ucva][:left],
        spherical: params[:spherical][:left],
        cylindrical: params[:cylindrical][:left],
        axis: params[:axis][:left],
        prism: params[:prism][:left],
        add: params[:add][:left],
        cva: params[:cva][:left],
        units: params[:units][:left],
        prism2: params[:prism2][:left],
        units2: params[:units2][:left]

    )

    @right_correction_component.update(
        ucva: params[:ucva][:right],
        spherical: params[:spherical][:right],
        cylindrical: params[:cylindrical][:right],
        axis: params[:axis][:right],
        prism: params[:prism][:right],
        add: params[:add][:right],
        cva: params[:cva][:right],
        units: params[:units][:right],
        prism2: params[:prism2][:right],
        units2: params[:units2][:right]
    )

    redirection_url = "#{request.protocol}#{request.host}/customers/#{@customer.id}/health_assessments/#{@health_assessment.id}"

    if @prescription.save && @left_correction.save && @right_correction.save && @right_correction_component.save && @left_correction_component.save
      redirect_to redirection_url
    else
      render text: 'error', status: :unprocessable_entity
    end

  end

  def destroy
    health_assessment = HealthAssessment.find(params[:health_assessment_id])
    customer = health_assessment.customer
    prescription = health_assessment.prescription
    left_correction = prescription.corrections.find_by(eye: 'left')
    right_correction = prescription.corrections.find_by(eye: 'right')

    redirection_url = "#{request.protocol}#{request.host}/customers/#{customer.id}/health_assessments/#{health_assessment.id}"

    if prescription.destroy && left_correction.destroy && right_correction.destroy
      redirect_to redirection_url
    else
      render text: 'error', status: :unprocessable_entity
    end

  end

  protected

  def prescription_params
    params.require(:prescription).permit!
  end
end
