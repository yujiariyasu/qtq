class LearningsController < ApplicationController
  INITIAL_DECREASE_SPEED = 67
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    @chart = @learning.review_chart
    @review = Review.new
  end

  def create
    params[:learning][:proficiency_decrease_speed] = INITIAL_DECREASE_SPEED
    params[:learning][:next_review_date] = Time.current.to_date.tomorrow
    learning = Learning.new(learning_params)
    if learning.save
      flash[:info] = '学習を登録しました。'
      redirect_to learning_url(learning)
    else
      flash[:danger] = '学習の登録に失敗しました。'
      redirect_to params[:url]
    end
  end

  def update
    learning = Learning.find(params[:id])
    params[:learning][:title] = learning.title if params[:learning][:title].blank?
    params[:learning][:description] = learning.description if params[:learning][:description].blank?
    unless learning.update(learning_params)
      flash[:danger] = '学習の登録に失敗しました。'
    end
    redirect_to learning_url(learning)
  end

  private
  def learning_params
    params.require(:learning).permit(:title, :description, {images: []}, :study_time,
      :proficiency_decrease_speed, :next_review_date).merge(user_id: current_user.id)
  end
end
