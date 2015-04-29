class Staff::PromotionsController < StaffController
  before_action :promotions_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path


  def new
    @promotion=Promotion.new
  end

  def index
    @promotion=Promotion.all

    add_breadcrumb 'Promotions'
  end

  def show
    @promotion=Promotion.find(params[:id])
    #@promo_code=@promotion.PromoCode

  end


  def create
    @promotion= Promotion.new(promotion_params)
    start_date=promotion_params[:start_date].to_date
    unless(start_date.nil?)
      @promotion.expiry_date=start_date.advance(years:1)
    end
    pre=generate_prefix(promotion_params[:title])
    @promotion.prefix=pre
    if @promotion.save
      @promotion.insert_promo_codes(@promotion.generate_codes,pre)
      redirect_to staff_promotions_path
    else
      render new_staff_promotion_path
    end
  end

  def update

  end


  protected
  def promotions_active
    @promotions_active = true
  end

  def promotion_params
    params.require(:promotion).permit(:id,:prefix,:title,:description,:start_date,:generate_codes)
  end

  #To generate prefix for promotion
  def generate_prefix (title)
    prefix="EK"
    unless(title.nil?)
      prefix=title[0..1].upcase
    end
  end

end
