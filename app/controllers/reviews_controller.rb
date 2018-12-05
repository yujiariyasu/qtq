class ReviewsController < ApplicationController
  def create
    review = Review.new(review_params)
    unless review.save
      flash[:danger] = '学習の登録に失敗しました。'
    end
    redirect_to learning_url(params[:learning_id])
  end

  private
  def review_params
    params.require(:review).permit(:description, :proficiency).merge(learning_id: params[:learning_id])
  end
end
