class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  rescue_from Exception, with: :rescue500

  def rescue500(e)
    @exception = e
    render 'errors/internal_server_error', status: 500
  end
end
