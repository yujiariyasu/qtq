class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email if Rails.env.production?
      flash[:info] = "メールを送信しました。"
      redirect_to root_url
    else
      flash[:info] = "無効なメールアドレスです。"
      render 'new'
    end
  end
end