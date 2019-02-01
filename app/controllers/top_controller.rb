class TopController < ApplicationController
  include Chart
  def root
    if logged_in?
      session[:path_info] = request.path_info
      @user = current_user
      @comparison_chart = comparison_chart(@user)
      @schedule_chart = schedule_chart(@user)
      @today_review_learnings = @user.learnings.review_today
      render 'users/show'
    else
      @learnings = Learning.includes(:user).order(id: :desc).page(params[:page]).per(30)
      @title = '新着'
      render 'shared/learnings'
    end
  end
end
