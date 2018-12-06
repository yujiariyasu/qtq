class ReviewsController < ApplicationController
  def create
    review = Review.new(review_params)
      flash[:info] = '復習を記録しました。'
    unless review.save
      flash[:danger] = '復習の記録に失敗しました。'
    end
    redirect_to learning_url(params[:learning_id])
  end

  private
  def review_params
    params.require(:review).permit(:description, :proficiency).merge(learning_id: params[:learning_id])
  end
end
