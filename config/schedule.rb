set :output, 'log/crontab.log'
set :environment, 'production'

every 1.day, :at => ['9:30 am', '8:00 pm'] do
  rake "webpush:send"
end
