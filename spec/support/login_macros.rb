module LoginMacros
  def set_media_user_session(user)
    session[:media_user_id] = user.id
    session[:media_user_updated_at] = user.updated_at
  end
end