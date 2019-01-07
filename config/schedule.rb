set :output, 'log/crontab.log'
set :environment, 'production'

every 1.day, :at => ['4:30 am', '6:00 pm'] do
  rake "webpush:send"
end
