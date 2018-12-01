class ApplicationMailer < ActionMailer::Base
  default from: 'RootedLearning',
          reply_to: ENV['ROOTED_MAIL']
  layout 'mailer'
end
