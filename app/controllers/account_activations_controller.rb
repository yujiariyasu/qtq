class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = 'アカウントの認証に成功しました。'
      log_in user
      redirect_to user
    else
      flash[:danger] = '無効なURLです。'
      redirect_to root_url
    end
  end
end
