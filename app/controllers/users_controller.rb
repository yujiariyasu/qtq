class UsersController < ApplicationController
  include Chart

  before_action :logged_in_user,   only: [:edit, :update]
  before_action :exist_user?,   only: [:show, :edit, :followers, :following]
  before_action :correct_user,   only: :edit
  before_action :correct_update_user,   only: :update

  def index
    @description = '一覧'
    @users = User.all.page(params[:page]).per(20)
    @title = "ユーザー一覧"
    render 'shared/users'
  end

  def show
    session[:path_info] = request.path_info
    @comparison_chart = comparison_chart(@user)
    @schedule_chart = schedule_chart(@user)
  end

  def new
    session[:path_info] = request.path_info
    @user = User.new
  end

  def create
    params[:password_confirmation] = params[:password]
    if env['omniauth.auth'].present?
      # Facebookログイン
      @user = User.from_omniauth(env['omniauth.auth'])
      if @user.save(context: :facebook_login)
        @user.activate
        log_in @user
        flash[:info] = 'Facebookログインしました。'
        redirect_to user_url(@user.name) and return
      else
        flash[:danger] = 'Facebookログインに失敗しました。'
        if session[:path_info] == '/'
        redirect_to root_path and return
        elsif session[:path_info] == '/login'
        redirect_to login_path and return
        elsif session[:path_info] == '/users/new'
        redirecto_to new_user_path and return
        end
      end
    end
    @user = User.new(create_params)
    result = @user.save
    if @user.save
      if Rails.env.production?
        flash[:info] = 'ユーザー認証のためのメールを送信しました。'
        @user.send_activation_email
        log_in @user
      else
        flash[:info] = 'ユーザー登録に成功しました。'
        @user.activate
        log_in @user
      end
      redirect_to user_url(@user.name)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(name: params[:name])
  end

  def update
    if @user.update_attributes(update_params)
      unless params[:user][:goal]
        if params[:delete_avatar_flag] == 'true'
          @user.remove_avatar!
          @user.save
        end
        flash.now[:success] = 'プロフィールを更新しました。'
      end
      redirect_to user_url(@user.name)
    else
      render 'edit'
    end
  end

  def following
    @description = ' / フォローしている人'
    @path = user_path(@user.name)
    @link_text = @user.name
    @users = @user.following.page(params[:page]).per(20)
    @title = "#{@user.name}さんがフォローしている人一覧"
    render 'shared/users'
  end

  def followers
    @description = ' / フォロワー'
    @path = user_path(@user.name)
    @link_text = @user.name
    @users = @user.followers.page(params[:page]).per(20)
    @title = "#{@user.name}さんのフォロワー一覧"
    render 'shared/users'
  end

  def likers
    @description = ' / いいねした人'
    @learning = Learning.find_by(id: params[:id])
    @path = learning_path(@learning)
    @link_text = @learning.title
    @users = @learning.users.page(params[:page]).per(20)
    @title = "#{@learning.title} にいいねした人"
    render 'shared/users'
  end

  private
  def create_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :introduction).merge(goal: 5)
  end

  def update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :goal, :introduction)
  end

  def correct_user
    @user = User.find_by(name: params[:name])
    redirect_to root_url unless current_user?(@user)
  end

  def correct_update_user
    @user = User.find_by(id: request.path.delete('/users/'))
    redirect_to root_url unless current_user?(@user)
  end
end
