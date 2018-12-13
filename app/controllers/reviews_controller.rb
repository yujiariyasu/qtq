class ReviewsController < ApplicationController
  def create
    review = Review.new(review_params)
      flash[:info] = '復習を記録しました。'
    if review.save
      learning = Learning.find(params[:id])
      learning.update_next_review_date_and_speed(review.proficiency)
      redirect_to learning_url(params[:learning_id])
    else
      flash[:danger] = '復習の記録に失敗しました。'
      redirect_to learning_url(params[:learning_id])
    end
  end

  private
  def review_params
    params.require(:review).permit(:description, :proficiency).merge(learning_id: params[:id])
  end
end
