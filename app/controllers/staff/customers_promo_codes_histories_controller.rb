class Staff::CustomersPromoCodesHistoriesController < StaffController

  def new
  end

  def index
    @Health_Assessment_promo_code=HealthAssessmentPromoCode.all
  end

  def create
    @customer = Customer.find(params[:customer_id])
    promo_code=params[:health_assessment_promo_code][:code]
    promo_code=promo_code.strip
    if(validate_promo_code(promo_code,params[:health_assessment_promo_code][:health_assessment_id]))
      PromoCode.update(PromoCode.find_by_code(promo_code).id, :customer_id =>params[:customer_id],:status=>true)
      @health_promo_code=HealthAssessmentPromoCode.new
      @health_promo_code.promo_code_id=PromoCode.find_by_code(promo_code).id
      @health_promo_code.health_assessment_id=params[:health_assessment_promo_code][:health_assessment_id]
      if(@health_promo_code.save)
        render partial: "new_health_assessment_promo_code"
      else
        failure_msg
      end
    else
        failure_msg
    end
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @health_promo_code=HealthAssessmentPromoCode.find(params[:id])
    promo_code=params[:health_assessment_promo_code][:code]
    id=params[:health_assessment_promo_code][:health_assessment_id]
    unless(PromoCode.find_by_code(promo_code).nil?)
      @health_promo_code.update(health_assessment_id: id,promo_code_id:PromoCode.find_by_code(promo_code).id)
    end
    render partial: "update_promo_code"
  end

  def destroy
  end

  protected
  def health_assessment_promo_code_params
    params.require(:health_assessment_promo_code).permit(:code,:health_assessment_id)
  end




  def validate_promo_code(promo_code,health_assessment_id)
      unless(PromoCode.find_by_code(promo_code).nil?)
        promo_code_id=PromoCode.find_by_code(promo_code).id
        health_assessment_promo_code=HealthAssessmentPromoCode.where('promo_code_id=?',promo_code_id)
        if(health_assessment_promo_code.empty?)
          if((HealthAssessmentPromoCode.find_by_health_assessment_id(health_assessment_id.to_i)).nil?)
            return true
          end
        end
        unless(((HealthAssessmentPromoCode.where('promo_code_id=?',promo_code_id)).count)>=3)
          if((HealthAssessmentPromoCode.find_by_health_assessment_id(health_assessment_id)).nil?)
            return true
          else
            self.set_message='Duplicate Health Assessment'
          end
        else
            self.set_message='Invalid Promo Code'
        end
      else
        self.set_message='Invalid Promo Code'
      end
    return false
  end

  def failure_msg
    render json: {msg: set_message}, status: :unprocessable_entity
  end

  def set_message
    @message
  end

  def set_message=(message)
    @message = message
  end
end

