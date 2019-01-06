class UsersController < ApplicationController
  include Chart

  before_action :logged_in_user,   only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    session[:path_info] = request.path_info
    @user = params[:id] ? User.find(params[:id]) : User.find(1)
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
        redirect_to @user and return
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
    @user = User.new(user_params)
    result = @user.save
    if @user.save
      if Rails.env.production?
        @user.send_activation_email
        flash[:info] = 'ユーザー認証のためのメールを送信しました。'
      else
        flash[:info] = 'ユーザー登録に成功しました。'
        @user.activate
        log_in @user
      end
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      unless params[:user][:goal]
        flash.now[:success] = 'プロフィールを更新しました。'
      end
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @description = ' / following'
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(20)
    @title = "#{@user.name}さんがフォローしている人"
    render 'shared/users'
  end

  def followers
    @description = ' / followers'
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(20)
    render 'shared/users'
  end

  def learnings
    @description = ' / learnings'
    @user = User.find(params[:id])
    @learnings = @user.learnings.page(params[:page]).per(20)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :introduction).merge(goal: 10)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
