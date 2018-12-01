class LearningsController < ApplicationController
  def create
    @learning = Learning.new(learning_params)
    if @learning.save
      flash[:info] = '学習の登録しました。'
    else
      flash[:danger] = '学習の登録に失敗しました。'
    end
    render params[:url]
  end

  private
  def learning_params
    params.require(learning).permit(:title, :description, :image).merge(use_id: current_user.id)
  end
end
