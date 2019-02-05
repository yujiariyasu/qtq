class UserRelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    parameters = { active_user_id: current_user.id, passive_user_id: @user.id, learning_id: 1 }
    FollowActivity.create(parameters) unless current_user == @user || FollowActivity.where(parameters).present?
    respond_to do |format|
      format.html { redirect_to user_url(@user) }
      format.js
    end
  end

  def destroy
    @user = UserRelationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to user_url(@user) }
      format.js
    end
  end
end
