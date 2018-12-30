class LearningLikesController < ApplicationController
  def create
    LearningLike.create(user_id: current_user.id, learning_id: params[:learning_id])
    @learning = Learning.find(params[:learning_id])
  end

  def destroy
    like = LearningLike.find_by(user_id: current_user.id, learning_id: params[:learning_id])
    like.destroy
    @learning = Learning.find(params[:learning_id])
  end
end
