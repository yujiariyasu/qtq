module ApplicationHelper
  def current_user_avatar_or
    return logged_in? && current_user.avatar.file ? current_user.avatar :
      "https://s3-ap-northeast-1.amazonaws.com/rootedlearning/uploads/default/avatar.jpg"
  end

end
