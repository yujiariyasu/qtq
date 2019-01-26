class ActivitiesController < ApplicationController
  before_action :exist_user_with_params_user_name?,   only: :index
  def index
    @description = ' / 通知一覧'
    @activities = @user.passive_activities.order(id: :desc).includes(:active_user, :learning).page(params[:page]).per(20)
    @activities.update_all(pushed: true, checked: true)
    @title = "#{@user.name}さんの通知一覧"
  end

  def update
    activity = Activity.find(params[:id])
    if activity.type == 'CommentActivity' || activity.type == 'LearningLikeActivity'
      learning = activity.learning
      path = learning_path(learning)
      learning.activities.where(passive_user: current_user).update_all(pushed: true)
    elsif activity.type == 'FollowActivity'
      FollowActivity.where(passive_user: current_user).update_all(pushed: true)
      path = user_path(activity.active_user)
    end
    redirect_to path
  end

  def check
    User.find_by(name: params[:user_name]).passive_activities.each do |activity|
      activity.update(checked: true)
    end
    render nothing: true
  end
end
