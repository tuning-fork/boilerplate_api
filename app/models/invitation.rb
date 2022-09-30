# frozen_string_literal: true

class Invitation < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { scope: :organization }

  belongs_to :organization
  belongs_to :user, optional: true
end
