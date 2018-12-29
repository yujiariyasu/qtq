class CommentsController < ApplicationController
  def create
    @comment = Comment.create!(comment_params)
  end

  private
  def comment_params
    params.require(:comment).permit(:body).merge(learning_id: params[:learning_id])
  end
end
