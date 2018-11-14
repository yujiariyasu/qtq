class UsersController < ApplicationController
  before_action :logged_in_user,   only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    category = [1,3,5,7]
    current_quantity = [1000,5000,3000,8000]
    months = [ 4, 5, 6, 7, 8, 9 ]
    product_A_sales = [ 1_000_000, 1_200_000, 1_300_000,
      1_400_000, 1_200_000, 1_100_000 ]
    product_B_sales = [   300_000,   500_000,   750_000,
      1_150_000, 1_350_000, 1_600_000 ]
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ItemXXXの在庫の推移')
      f.xAxis(categories: category)
      f.series(name: '在庫数', data: current_quantity)
    end


    @chart2 = LazyHighCharts::HighChart.new("graph") do |f|
      f.title(text: 'ItemXXXの在庫の推移')
      f.xAxis(categories: category)
      f.series(name: '在庫数', data: current_quantity)
    end

    @chart3 = LazyHighCharts::HighChart.new("graph") do |c|
      c.chart(type: "pie")
      c.title(text: "復習の予定")
      c.subtitle(text: "Click the slices to view detail!!")
      c.plotOptions(series: {allowPointSelect: true,cursor: 'pointer',dataLabels: {
          enabled: true, format: '{point.name}',
        }
      })
      c.tooltip(
        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>'
      )
      c.series({
        name: '復習時間',
        colorByPoint: true,
        data: [
          {
              "name": "明日：3時間",
              "y": 3,
              "drilldown": "明日"
          },
          {
              "name": "あさって：2時間",
              "y": 3,
              "drilldown": "あさって"
          },
          {
              "name": "しあさって：2時間",
              "y": 2,
              "drilldown": "しあさって"
          },
          {
              "name": "4日後〜1ヶ月後：2時間",
              "y": 3,
              "drilldown": "4日後〜1ヶ月後"
          },
          {
              "name": "1ヶ月後以降：2時間",
              "y": 4,
              "drilldown": "1ヶ月後以降"
          }
        ]
      })
      c.drilldown( { series: [
          { "name": "明日",
            "id": "明日",
            "data": [
              ["PerfectRuby：2時間", 2],
              ["プログラムはなぜ動くのか：10分", 0.18],
              ["jsの本：1時間", 1],
            ]
          },
          { "name": "あさって",
            "id": "あさって",
            "data": [
              ["PerfectRuby：2時間", 2],
              ["プログラムはなぜ動くのか：50分", 0.83],
            ]
          },
        ]
      })
    end
  end

  def new
    @user = User.new
  end

  def create
    if env['omniauth.auth'].present?
      # Facebookログイン
      @user = User.from_omniauth(env['omniauth.auth'])
      if @user.save(context: :facebook_login)
        @user.activate
        log_in @user
        flash[:info] = "Facebookログインしました。"
        redirect_to @user and return
      else
        flash[:danger] = 'Facebookログインに失敗しました。'
        redirect_to root_path and return
      end
    end
    @user = User.new(user_params)
    result = @user.save
    if @user.save
      if Rails.env.production?
        @user.send_activation_email
        flash[:info] = "ユーザー認証のためのメールを送信しました。"
      else
        flash[:info] = "ユーザー登録に成功しました。"
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
      flash.now[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
