class CommentsController < ApplicationController
  def create
    @comment = Comment.create!(comment_params)
  end

  def update
    Comment.find(params[:id]).update(update_params)
    flash[:info] = 'コメントを編集しました。'
    redirect_to learning_url(params[:learning_id])
  end

  def destroy
    Comment.find(params[:id]).destroy
    @comment_selector = "#comment#{params[:id]}"
  end

  private
  def comment_params
    strip_body(params.require(:comment).permit(:body).merge(learning_id: params[:learning_id], user_id: current_user.id))
  end

  def update_params
    strip_body(params.require(:comment).permit(:body))
  end

  def strip_body(params_hash)
    params_hash['body'] = params_hash['body'].my_strip if params_hash[:body].present?
    params_hash
  end
end
