namespace :webpush do
  desc "全ユーザーにwebpushを送るタスク"
  task send: :environment do
    User.all.each { |u| u.webpush }
  end
end
