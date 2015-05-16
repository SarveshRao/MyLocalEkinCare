class Promotion < ActiveRecord::Base
  include ApplicationHelper
  #belongs_to :partner
  has_many :PromoCode
  validates :title,:start_date,presence:true
  validates :title,uniqueness:true

  # To Insert promo codes for promotion
  def insert_promo_codes(codes_count,promotion_prefix)
    count=0
    until count>=codes_count
      identifier=generate_promo_code(promotion_prefix)
      Rails.logger.debug("My object -----: #{identifier.inspect}")
      PromoCode.create(code:identifier,promotion_id:self.id,status:false,created_at:Time.now.utc,updated_at:Time.now.utc);
      count=count+1
    end
  end

  # To Generate new promo code
  def generate_promo_code(promotion_prefix)
    partner_prefix='EK'
    unless self.partner_id.nil?
      partner_prefix=Partner.find(self.partner_id).code
    end
    rand_num = SecureRandom.random_number(99999999)
    identifier = partner_prefix+promotion_prefix+"#{padding_zeros(rand_num, 8)}"

    if PromoCode.exists?(code: identifier)
      generate_promo_code(promotion_prefix)
    end

    identifier
  end


  def get_partner_codes
    codes=Partner.pluck(:code)
    codes.push('select')
  end

end
