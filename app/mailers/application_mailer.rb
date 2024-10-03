# frozen_string_literal: true

# ApplicationMailer is the base class for all mailers in the application.
# It provides common configurations or methods that can be used by all other mailer classes.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
