# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8, wrong_length: 'Password must be at least 8 characters.' }, if: :password

  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users

  has_secure_password

  def to_s
    "#<User:#{id}>"
  end

  def send_password_reset
    self.password_reset_token = generate_base64_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_now
    logger.info("Password reset token generated for #{self}")
  end

  def password_token_valid?
    (password_reset_sent_at + 1.hour) > Time.zone.now
  end

  def reset_password(password)
    self.password_reset_token = nil
    self.password = password
    save!
  end

  def in_organization?(organization_id)
    organizations.any? { |organization| organization.id == organization_id }
  end

  private

  def generate_base64_token
    SecureRandom.urlsafe_base64
  end
end
