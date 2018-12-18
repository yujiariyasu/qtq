class ApplicationMailer < ActionMailer::Base
  default from: 'qtq.work',
          reply_to: ENV['MAIL']
  layout 'mailer'
end
