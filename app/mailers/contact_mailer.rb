class ContactMailer < ApplicationMailer

    def contact_submission(contact_submission)
      @contact = contact_submission
      mail to: "boilerplate.app.test@gmail.com", subject: "New Contact Submission: #{@contact.name} at #{@contact.organization_name}"
    end
    
    def contact_confirmation(contact_submission)
        @contact = contact_submission
        mail to: @contact.email, subject: "Contact Confirmation: Boilerplate App"
    end
end