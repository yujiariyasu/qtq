class UsersController < ApplicationController
  before_action :logged_in_user,   only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    session[:path_info] = request.path_info
    @user = params[:id] ? User.find(params[:id]) : User.find(4)
    category = (1..30).to_a
    date_category = category.map{ |date| "#{date}日目" }
    day_array = [4, 2, 4, 6, 1, 4, 2, 1, 5, 4, 3, 4, 2, 1, 5, 8, 4, 2, 4, 6, 1, 4, 2, 1, 5, 4, 3, 4, 2, 1]
    days1 = day_array.sample(day_array.size)
    days2 = days1.sample(days1.size)
    days3 = days2.sample(days2.size)
    text = 'いい調子!!'

    @chart2 = LazyHighCharts::HighChart.new('graph') do |c|
      c.chart(type: 'column')
      c.subtitle(text: text)
      c.xAxis( {
        categories: date_category,
        crosshair: true
      })
      c.tooltip( {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y} 時間</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      })
      c.plotOptions( {
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      })
      c.series(type: 'spline', name: '目標', data: [2]*30,
               marker: {
                 lineWidth: 1,
                 lineColor: 'white',
                 fillColor: 'white'
               })
      c.series(name: 'あなた', data: days1)
      c.series(name: 'ライバル1', data: days2)
      c.series(name: 'ライバル2', data: days3)
    end

    text = '明日は3時間分の復習です!!'
    @chart3 = LazyHighCharts::HighChart.new('graph') do |c|
      c.chart(type: 'pie')
      c.subtitle(text: text)
      c.plotOptions(series:{allowPointSelect: true, cursor: 'pointer',
          dataLabels: {enabled: true, format: '{point.name}'}}
      )
      c.tooltip(
        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>'
      )
      c.series({
        name: '復習',
        colorByPoint: true,
        data: [
          {
              name: '明日：3時間',
              y: 3,
              drilldown: '明日'
          },
          {
              name: 'あさって：2時間',
              y: 3,
              drilldown: 'あさって'
          },
          {
              name: 'しあさって：2時間',
              y: 2,
              drilldown: 'しあさって'
          },
          {
              name: '4日後〜1ヶ月後：2時間',
              y: 3,
              drilldown: '4日後〜1ヶ月後'
          },
          {
              name: '1ヶ月後以降：2時間',
              y: 4,
              drilldown: '1ヶ月後以降'
          }
        ]
      })
      c.drilldown( { series: [
          { name: '明日',
            id: '明日',
            data: [
              ['PerfectRuby：2時間', 2],
              ['プログラムはなぜ動くのか：10分', 0.18],
              ['jsの本：1時間', 1]
            ]
          },
          { name: 'あさって',
            id: 'あさって',
            data: [
              ['PerfectRuby：2時間', 2],
              ['プログラムはなぜ動くのか：50分', 0.83]
            ]
          }
        ]
      })
    end
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
      flash.now[:success] = 'プロフィールを更新しました。'
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
