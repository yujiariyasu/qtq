class LearningsController < ApplicationController
  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    reviews = @learning.reviews
    review_data = [100]
    decrease_speed = 67
    review_date_proficiency_map = {}
    reviews.each do |review|
      review_date_proficiency_map[review.created_at.to_date.next_day] = review.proficiency
    end
    (@learning.created_at.to_date..Time.now.to_date).each do |date|
      if review_date_proficiency_map.keys.include?(date)
        review_data << 100
        decrease_speed /= (1 + review_date_proficiency_map[date] * 2 / 100)
        next
      end
      last_data = review_data[-1] - decrease_speed
      last_data = 0 if last_data < 0
      review_data << last_data
    end
    elapsed_days_num = reviews.present? ? @learning.elapsed_days_num : 1
    range = elapsed_days_num > 9 ? 1..elapsed_days_num : 1..10
    date_category = range.to_a.map{ |date| "#{date}日目" }
    if review_data[-1] > 70
      text = 'イイ感じ..'
    elsif review_data[-1] > 40
      text = 'そろそろ復習..'
    elsif review_data[-1] > 10
      text = '頑張ろう..'
    else
      text = 'ヤバいよヤバいよ..'
    end
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
