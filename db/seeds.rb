# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: Time.zone.now)
# end

# users = User.order(:created_at).take(6)
# 50.times do
#   description = Faker::Lorem.sentence(5)
#   title = Faker::Artist.name
#   users.each { |user| user.learnings.create!(title: title, description: description) }
# end

users = User.where(id: [111,112,113,114,115])
learnings = Learning.order(:created_at).take(6)
4.times do
  body = Faker::Lorem.sentence(5)
  users.each do |user|
    learnings.each do |l|
      l.comments.create!(body: body, user_id: user.id)
    end
  end
end


# users = User.all
# user  = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }
