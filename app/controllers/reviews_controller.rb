class ReviewsController < ApplicationController
  def create
    review = Review.new(learning_id: params[:id])
    if review.save
      flash[:info] = '復習を記録しました。'
      learning = Learning.find(params[:id])
      learning.update_with_review(params[:review][:finish_flag], params[:review][:proficiency].to_i, params[:description], review.first_in_the_day?)
      redirect_to learning_url(params[:id])
    else
      flash[:danger] = '復習の記録に失敗しました。'
      redirect_to learning_url(params[:id])
    end
  end
end
