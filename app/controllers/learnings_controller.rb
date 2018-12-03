class LearningsController < ApplicationController
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    date_category = (1..10).to_a.map{ |date| "#{date}" }
    text = 'そろそろ復習..'
    # TODO: x軸の長さによって後ろに何日足すか変える
    @chart = LazyHighCharts::HighChart.new('graph') do |c|
      c.subtitle(text: text)
      c.xAxis(labels: { format: '{value + 1}日目' })
      c.yAxis(title: { text: nil },
              labels: { format: '{value}%' },
              max: 100)
      c.legend(layout: 'vertical', align: 'right', verticalAlign: 'top')
      c.plotOptions(line: { dataLabels: { enabled: true } },
        spline: {marker: {radius: 4,
                          lineColor: '#666666',
                          lineWidth: 1}})
      c.series(type: 'spline', name: '定着率',
               data: [100, 70, 100, 80, 70, 60,nil,nil,nil,nil]
      )
      c.chart(defaultSeriesType: "column")
      c.legend(maxHeight: 80)
      c.tooltip(shared: true)
    end
  end

  def create
    @learning = Learning.new(learning_params)
    if @learning.save
      flash[:info] = '学習を登録しました。'
    else
      flash[:danger] = '学習の登録に失敗しました。'
    end
    redirect_to params[:url]
  end

  private
  def learning_params
    params.require(:learning).permit(:title, :description, :image).merge(user_id: current_user.id)
  end
end
