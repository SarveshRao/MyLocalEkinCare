class Identity < ActiveRecord::Base
  belongs_to :customer
  # validates_presence_of :customer
  validates_presence_of :uid, :provider
  validates :uid, uniqueness: {scope: [:provider, :customer]}

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
