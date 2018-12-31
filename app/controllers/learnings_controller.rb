class LearningsController < ApplicationController
  include Chart
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    @chart = review_chart(@learning)
    @review = Review.new
    @comment = Comment.new
    @comments = @learning.comments.includes(:user)
  end

  def create
    if params[:learning][:proficiency].to_i == 100
      speed = 16
    else
      speed = (70 - params[:learning][:proficiency].to_i / 2)
    end
    learning = Learning.new(learning_params(speed))
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
    difference = learning.proficiency - params[:learning][:proficiency].to_i / 2
    speed = difference + learning.proficiency_decrease_speed
    speed = 100 if speed > 100
    speed = 1 if speed < 1
    update_params = learning_params(speed)
    update_params[:title] = update_params[:title].presence || learning.title
    unless learning.update(update_params)
      flash[:danger] = '学習の編集に失敗しました。'
    end
    redirect_to learning_url(learning)
  end

  def destroy
   Learning.find(params[:id]).destroy
   redirect_to user_url(current_user)
  end

  def likers
    @description = ' / likers'
    @learning = Learning.find(params[:id])
    @users = @learning.users.page(params[:page]).per(20)
    @title = "#{@learning.title} にいいねした人"
    render 'shared/users'
  end

  def trend
    @learnings = Learning.page(params[:page]).per(30)
  end

  private
  def learning_params(speed)
    params.require(:learning).permit(:title, :description, {images: []}, :proficiency,
      :proficiency_decrease_speed, :next_review_date, :public_flag)
      .merge(user_id: current_user.id, proficiency_decrease_speed: speed, next_review_date: Time.current.to_date.tomorrow)
  end
end
