class Staff::PromoCodesController < StaffController

  add_breadcrumb 'Home', :staff_staff_charts_index_path

  def new
  end

  def show
  end

  def index
    promotion_id=params[:format]
    @promo_codes = PromoCode.where(:promotion_id => promotion_id)
    @promotion = Promotion.find(promotion_id)

    add_breadcrumb 'Promotions', :staff_promotions_path
    add_breadcrumb @promotion.title

  end

  def update
    @promo_code = PromoCode.find(params[:id])
    partner_code=result_params[:partner_id]
    partner=Partner.find_by_code(partner_code)
    part_id=partner.id
    status=result_params[:status]
    status_val=false
    if(status=='Used')
      status_val=true
    end
    @promo_code.update(:id=>params[:id],:status=>status_val,:partner_id=>part_id)
    @promo_code.save


    render partial: 'updated_promo_code'
  end


  def destroy
    PromoCode.find(params[:id]).delete
    render json: {status: 'success'}, status: 200
  end

  protected
  def result_params
    params.require(:promo_code).permit(:id, :code,:partner_id,:status,:format)
  end
end
