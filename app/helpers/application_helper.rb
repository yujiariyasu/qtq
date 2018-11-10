module ApplicationHelper
  def user_avatar_or_default(user)
    return user && user.avatar.file ? user.avatar :
      "https://s3-ap-northeast-1.amazonaws.com/rootedlearning/uploads/default/avatar.jpg"
  end

end
