class Contact < ApplicationRecord
    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :message, presence: true, length: { minimum: 5 }
end