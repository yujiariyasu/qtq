class ApplicationMailer < ActionMailer::Base
  default from: 'qtq.work',
          reply_to: ENV['ROOTED_MAIL']
  layout 'mailer'
end
