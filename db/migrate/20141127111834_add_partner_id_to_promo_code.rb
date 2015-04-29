class AddPartnerIdToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :partner_id, :integer
  end
end
