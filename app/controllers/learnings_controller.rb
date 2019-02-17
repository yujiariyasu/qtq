class LearningsController < ApplicationController
  include Chart

  before_action :exist_user?,   only: [:liked, :timeline]
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
    @today_review_learnings = @user.learnings.review_today
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
      redirect_to request.referrer
    end
  end

  def update
    learning = Learning.find(params[:id])
    update_params = learning_params(learning.proficiency_decrease_speed, learning.next_review_date)
    update_params[:title] = update_params[:title].presence || learning.title
    unless learning.update(update_params)
      flash[:danger] = '学習の編集に失敗しました。'
      redirect_to learning_url(learning) and return
    end
    flash[:info] = '学習を編集しました。'
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
    redirect_to root_url unless current_user?(@user)
    @learnings = Learning.where(user: current_user.following).or(Learning.where(user: current_user)).includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = 'タイムライン'
    render 'shared/learnings'
  end

  def trend
    @learnings = Learning.includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = '新着'
    render 'shared/learnings'
  end

  def search
    words = params[:word].my_strip.split(':')
    word = words[0]
    learnings = words.size >= 2 && words[1] == 'me' && logged_in? ? Learning.where(user: current_user) : Learning.all
    searced_learnings = learnings.searched_by(word).includes(:user).order(created_at: :desc)
    searced_learnings_by_tag = learnings.searched_by_tag(word).includes(:user).order(created_at: :desc)
    @learnings =  Kaminari.paginate_array((searced_learnings + searced_learnings_by_tag).uniq).page(params[:page]).per(100)
    @title = "検索結果 / #{word}"
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
      :proficiency_decrease_speed, :next_review_date, :finished)
      .merge(user_id: current_user.id, proficiency_decrease_speed: speed, next_review_date: next_review_date))
  end

  def strip_title(params_hash)
    params_hash['title'] = params_hash['title'].my_strip if params_hash['title'].present?
    return params_hash
  end
end
