module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if id = session[:user_id]
      @current_user ||= User.find_by(id: id)
    elsif id = cookies.signed[:user_id]
      user = User.find_by(id: id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
    forget(current_user)
  end

  def remember(user)
    user.remember
    cookies.parmanent.signed[:user_id] = user.id
    cookies.parmanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end
end