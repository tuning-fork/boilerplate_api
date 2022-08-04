class Contact < ApplicationRecord
    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :message, presence: true, length: { minimum: 5 }

    def send_contact_email(contact_submission)
        ContactMailer.contact_submission(contact_submission).deliver_now
        ContactMailer.contact_confirmation(contact_submission).deliver_now
    end
end