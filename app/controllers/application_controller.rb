class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :tag_list_to_gon
  before_action :short_activities
  before_action :get_new_learning_id

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

  def exist_user_with_params_user_name?
    @user = User.find_by(name: params[:user_name])
    raise ActiveRecord::RecordNotFound unless @user
  end

  class Forbidden < ActionController::ActionControllerError;end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?

  private

  def get_new_learning_id
    @last_learning_id = Learning.last.id + 1
  end

  def tag_list_to_gon
    gon.tag_list = Tag.pluck(:name)
  end

  def short_activities
    @short_activities = current_user.passive_activities.includes(:active_user, :learning).order(created_at: :desc).take(10) if logged_in?
  end
end
