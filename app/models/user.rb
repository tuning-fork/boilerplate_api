class User < ApplicationRecord
  has_many :organization_users
  has_many :organizations, through: :organization_users

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 5, wrong_length: "Password must be at least 5 characters." }, if: :password

  def send_password_reset
    self.password_reset_token = generate_base64_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_now
  end

  def password_token_valid?
    (self.password_reset_sent_at + 1.hour) > Time.zone.now
  end

  def reset_password(password)
    self.password_reset_token = nil
    self.password = password
    save!
  end

  private

  def generate_base64_token
    test = SecureRandom.urlsafe_base64
  end
end
