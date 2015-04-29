class Staff < ActiveRecord::Base
  has_one :promo_code
  attr_accessor :password
  before_save :encrypt_password
  belongs_to :admin, polymorphic: true
  validates_confirmation_of :password

  def self.authenticate(email, password)
    staff = Staff.where(email: email).where.not(admin_type: 'Provider').first
    if staff && staff.password_hash == BCrypt::Engine.hash_secret(password, staff.password_salt)
      staff
    else
      nil
    end
  end

  def email=(raw_email)
    self[:email]= raw_email.downcase
  end

  def encrypt_password
    self.password_salt = self.password_salt || BCrypt::Engine.generate_salt
    if password.to_s.strip.length > 0
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def gender_default_icon
    'avatar-m.png'
  end
end
