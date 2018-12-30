class CommentLikesController < ApplicationController
  def create
    CommentLike.create(user_id: current_user.id, comment_id: params[:comment_id])
    @comment = Comment.find(params[:comment_id])
  end

  def destroy
    like = CommentLike.find_by(user_id: current_user.id, comment_id: params[:comment_id])
    like.destroy
    @comment = Comment.find(params[:comment_id])
  end
end
