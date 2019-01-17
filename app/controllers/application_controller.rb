class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_tag_list_to_gon

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください。'
      redirect_to login_url
    end
  end

  def exist_user?
    @user = User.find_by(name: params[:name])
    raise ActiveRecord::RecordNotFound unless @user
  end

  class Forbidden < ActionController::ActionControllerError;end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?

  private

  def set_tag_list_to_gon
    gon.tag_list = Tag.pluck(:name)
  end
end
