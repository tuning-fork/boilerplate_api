# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('ACTION_MAILER_GMAIL_ACCOUNT')
  layout 'mailer'
end
