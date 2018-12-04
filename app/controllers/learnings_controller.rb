class LearningsController < ApplicationController
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    reviews = @learning.reviews
    review_data = [100]
    decrease_speed = 67
    date_array = []
    reviews.each do |review|
      date_array << review.created_at.to_date.next_day
    end
    (@learning.created_at.to_date..reviews.last.created_at.to_date.next_day).each do |date|
      if date_array.include?(date)
        review_data << 100
        next
      end
      last_data = review_date[-1] - decrease_speed
      last_data = 0 if last_data < 0
      review_data << last_data
    end
    review_data = [100, 70, 100, 80, 70, 60,-10,-20,-30,nil]
    elapsed_days_num = reviews.present? ? @learning.elapsed_days_num : 1
    range = elapsed_days_num > 9 ? 1..elapsed_days_num : 1..10
    date_category = range.to_a.map{ |date| "#{date}日目" }
    text = 'そろそろ復習..'
    @chart = LazyHighCharts::HighChart.new('graph') do |c|
      c.subtitle(text: text)
      c.xAxis(categories: date_category)
      c.yAxis(title: { text: nil },
              labels: { format: '{value}%' },
              max: 100, min: 0)
      c.legend(layout: 'vertical', align: 'right', verticalAlign: 'top')
      c.plotOptions(line: { dataLabels: { enabled: true } },
        spline: {marker: {radius: 4,
                          lineColor: '#666666',
                          lineWidth: 1}})
      c.series(type: 'spline', name: @learning.title,
               data: review_data
      )
      c.chart(defaultSeriesType: "column")
      c.legend(maxHeight: 80)
      c.tooltip(shared: true,
                pointFormat: '<b>{point.y} %</b>',)
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
