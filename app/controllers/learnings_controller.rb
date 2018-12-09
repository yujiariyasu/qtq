class LearningsController < ApplicationController
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    @review = Review.new
  end

  def create
    learning = Learning.new(learning_params)
    if learning.save
      flash[:info] = '学習を登録しました。'
    else
      flash[:danger] = '学習の登録に失敗しました。'
    end
    redirect_to params[:url]
  end

  def update
    learning = Learning.find(params[:id])
    params[:learning][:title] = learning.title if params[:learning][:title].blank?
    params[:learning][:description] = learning.description if params[:learning][:description].blank?
    params[:learning][:images] = learning.images if params[:learning][:images].blank?
    unless learning.update(learning_params)
      flash[:danger] = '学習の登録に失敗しました。'
    end
    redirect_to learning_url(learning)
  end

  private
  def learning_params
    params.require(:learning).permit(:title, :description, {images: []}).merge(user_id: current_user.id)
  end
end
