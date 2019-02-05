class LearningLikesController < ApplicationController
  def create
    LearningLike.create(user_id: current_user.id, learning_id: params[:learning_id])
    @learning = Learning.find(params[:learning_id])
    parameters = { active_user_id: current_user.id, passive_user_id: @learning.user_id, learning_id: @learning.id }
    LearningLikeActivity.create(parameters) unless current_user.id == @learning.user_id || LearningLikeActivity.where(parameters).present?
  end

  def destroy
    like = LearningLike.find_by(user_id: current_user.id, learning_id: params[:learning_id])
    like.destroy
    @learning = Learning.find(params[:learning_id])
  end
end
