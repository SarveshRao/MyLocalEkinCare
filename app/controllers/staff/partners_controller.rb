class Staff::PartnersController < StaffController
  before_action :partners_active
  add_breadcrumb 'Home', :staff_staff_charts_index_path


  def new
    @partner=Partner.new
  end

  def index
    @partner=Partner.all

    add_breadcrumb 'Partners'
  end

  def show
    partner = Partner.find(params[:id])
    @promo_codes=partner.promo_codes

    add_breadcrumb 'Partners', :staff_partners_path
    add_breadcrumb partner.title
  end

  def create
    @partner= Partner.new(partner_params)
    @partner.created_at=Time.now.utc
    @partner.updated_at=Time.now.utc
      if @partner.save
        redirect_to staff_partners_path
      else
        render new_staff_partner_path
      end
  end

  protected
  def partner_params
    params.require(:partner).permit(:code,:poc,:email,:mobile,:title,:description)
  end

  def partners_active
    @partners_active = true
  end

end
