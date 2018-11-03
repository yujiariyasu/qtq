class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(activated: true)
      user.update_attribute(activated_at: Time.zone.now)
      log_in user
      redirect_to user
    else
      flash[:danger] = '無効なURLです。'
      redirect_to root_url
    end
  end
end
