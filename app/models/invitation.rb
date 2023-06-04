# frozen_string_literal: true

class Invitation < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { scope: :organization }

  belongs_to :organization
  belongs_to :user, optional: true

  def to_s
    "#<Invitation:#{id}>"
  end

  def build_accept_link
    protocol = Rails.env.production? ? 'https' : 'http'
    host = ENV.fetch('FRONTEND_ORIGIN')
    params = { token:, first_name:, last_name:, email: }

    "#{protocol}://#{host}/accept_invite?#{params.to_query}"
  end
end
