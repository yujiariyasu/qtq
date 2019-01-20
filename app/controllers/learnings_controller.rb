class LearningsController < ApplicationController
  include Chart

  before_action :exist_user?,   only: :liked
  before_action :exist_user_with_params_user_name?,   only: :index

  def index
    @description = ' / learnings'
    @learnings = @user.learnings.order(id: :desc).page(params[:page]).per(20)
    @title = "#{@user.name}さんの学習一覧"
  end

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
    safe_params = learning_params(speed, Time.current.to_date.tomorrow)
    learning = Learning.new(safe_params)
    if learning.save
      learning.save_tags(params[:tag_names].split(','))
      flash[:info] = '学習を登録しました。'
      redirect_to learning_url(learning)
    else
      flash[:danger] = '学習の登録に失敗しました。'
      redirect_to params[:url]
    end
  end

  def update
    learning = Learning.find(params[:id])
    speed = params[:learning][:proficiency] == 0 ? 1 : (learning.proficiency_decrease_speed * (params[:learning][:proficiency].to_f / learning.proficiency)).to_i
    speed = 100 if speed > 100
    speed = 1 if speed == 0
    update_params = learning_params(speed, learning.next_review_date)
    update_params[:title] = update_params[:title].presence || learning.title
    unless learning.update(update_params)
      flash[:danger] = '学習の編集に失敗しました。'
    end
    learning.save_tags(params[:tag_names].split(','))
    if params['image_delete_flag'] == 'true'
      learning.remove_images!
      learning.save
    end
    redirect_to learning_url(learning)
  end

  def destroy
   Learning.find(params[:id]).destroy
   redirect_to user_url(current_user.name)
  end

  def timeline
    @learnings = Learning.includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = 'タイムライン'
    render 'shared/learnings'
  end

  def search
    word = params[:word].my_strip
    @learnings = Learning.searched_by(word).includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = "学習検索 / #{word}"
    render 'shared/learnings'
  end

  def liked
    @learnings = Learning.liked_by(@user).includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = 'いいねした学習'
    render 'shared/learnings'
  end

  private
  def learning_params(speed, next_review_date)
    strip_title(params.require(:learning).permit(:title, :description, {images: []}, :proficiency,
      :proficiency_decrease_speed, :next_review_date, :finish_flag)
      .merge(user_id: current_user.id, proficiency_decrease_speed: speed, next_review_date: next_review_date))
  end

  def strip_title(params_hash)
    params_hash['title'] = params_hash['title'].my_strip if params_hash['title'].present?
    return params_hash
  end
end
