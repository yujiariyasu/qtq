class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user.password_digest.nil?
      flash.now[:danger] = 'パスワードが設定されていないユーザーです。'
      render 'new' and return
    end
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "アカウントの認証が済んでいません。メールをチェックしてください。"
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
