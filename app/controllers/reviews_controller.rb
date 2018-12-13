class ReviewsController < ApplicationController
  def create
    review = Review.new(review_params)
      flash[:info] = '復習を記録しました。'
    if review.save
      learning = Learning.find(params[:id])
      learning.update_with_review(review.proficiency, params[:description])
      redirect_to learning_url(params[:id])
    else
      flash[:danger] = '復習の記録に失敗しました。'
      redirect_to learning_url(params[:id])
    end
  end

  private
  def review_params
    params.require(:review).permit(:proficiency).merge(learning_id: params[:id])
  end
end
