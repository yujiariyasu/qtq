module Chart
  extend ActiveSupport::Concern

  DATE_RANGE_NUM = 29
  INITIAL_DECREASE_SPEED = 67

  def schedule_chart(user)
    days_until_review_hash = Hash.new(0)
    review_detail_data = Hash.new { |h, k| h[k] = [] }
    user.learnings.not_finished.each do |learning|
      set_review_data(learning, review_detail_data, days_until_review_hash)
    end
    if user.learnings.not_finished.present?
      text = "復習で学習を定着させましょう!!"
    else
      text = '学習を登録すると円グラフが表示されます!!'
    end
    return LazyHighCharts::HighChart.new('graph') do |c|
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
        name: '😊',
        colorByPoint: true,
        data: [
          {
              name: "今日：#{days_until_review_hash[:today]}件",
              y: days_until_review_hash[:today],
              drilldown: '今日'
          },
          {
              name: "明日：#{days_until_review_hash[:tomorrow]}件",
              y: days_until_review_hash[:tomorrow],
              drilldown: '明日'
          },
          {
              name: "あさって：#{days_until_review_hash[:two_days_later]}件",
              y: days_until_review_hash[:two_days_later],
              drilldown: 'あさって'
          },
          {
              name: "しあさって：#{days_until_review_hash[:three_days_later]}件",
              y: days_until_review_hash[:three_days_later],
              drilldown: 'しあさって'
          },
          {
              name: "4日後〜1ヶ月後：#{days_until_review_hash[:four_days_later]}件",
              y: days_until_review_hash[:four_days_later],
              drilldown: '4日後〜1ヶ月後'
          },
          {
              name: "1ヶ月後以降：#{days_until_review_hash[:one_month_later]}件",
              y: days_until_review_hash[:one_month_later],
              drilldown: '1ヶ月後以降'
          }
        ]
      })
      c.drilldown( { series: [
          { name: '今日',
            id: '今日',
            data: review_detail_data[:today]
          },
          { name: '明日',
            id: '明日',
            data: review_detail_data[:tomorrow]
          },
          { name: 'あさって',
            id: 'あさって',
            data: review_detail_data[:two_days_later]
          },
          { name: 'しあさって',
            id: 'しあさって',
            data: review_detail_data[:three_days_later]
          },
          { name: '4日後〜1ヶ月後',
            id: '4日後〜1ヶ月後',
            data: review_detail_data[:four_days_later]
          },
          { name: '1ヶ月後以降',
            id: '1ヶ月後以降',
            data: review_detail_data[:one_month_later]
          }
        ]
      })
    end
  end

  def set_review_data(learning, review_detail_data, days_until_review_hash)
    title = learning.title
    title = "#{title[0..20]}..." if title.size > 20
    days_until_review = (learning.next_review_date - Time.current.to_date).to_i
    case days_until_review
    when 1
      review_detail_data[:tomorrow] << [title, 1]
      days_until_review_hash[:tomorrow] += 1
    when 2
      review_detail_data[:two_days_later] << [title, 1]
      days_until_review_hash[:two_days_later] += 1
    when 3
      review_detail_data[:three_days_later] << [title, 1]
      days_until_review_hash[:three_days_later] += 1
    when 4..30
      review_detail_data[:four_days_later] << [title, 1]
      days_until_review_hash[:four_days_later] += 1
    when (31..Float::INFINITY)
      review_detail_data[:one_month_later] << [title, 1]
      days_until_review_hash[:one_month_later] += 1
    else
      review_detail_data[:today] << [title, 1]
      days_until_review_hash[:today] += 1
    end
  end

  def comparison_chart(user)
    today = Time.current.to_date
    range_size = (today - user.created_at.to_date).to_i
    if range_size >= DATE_RANGE_NUM
      range = (today - DATE_RANGE_NUM)..today
      range_size = DATE_RANGE_NUM
    else
      range = user.created_at.to_date..today
    end
    date_category = range.to_a.map{ |date| date.strftime('%m/%d') }
    learning_for_each_day = user.learning_for_each_day(range)
    unit = '件'
    goal = user.goal
    days1 = learning_for_each_day.sample(learning_for_each_day.size)
    days2 = days1.sample(learning_for_each_day.size)
    # 他の処理のついでにやればクエリ1つ減らせるが、メンテしにくくなるので別処理にします
    number_of_learnings = user.number_of_learnings(Date.today, range_size)
    goal_of_learnings_num = (range_size + 1) * goal
    if number_of_learnings == 0
      text = '学習を登録してみましょう!!'
    elsif number_of_learnings >= goal_of_learnings_num * 2
      text = '目標をあげよう!!'
    elsif number_of_learnings >= goal_of_learnings_num
      text = 'その調子!!'
    elsif number_of_learnings >= goal_of_learnings_num / 2
      text = 'もう少し頑張れる!!'
    else
      text = '目標が高すぎるかも？'
    end
    return LazyHighCharts::HighChart.new('graph') do |c|
      c.chart(type: 'column')
      c.subtitle(text: text)
      c.xAxis( {
        categories: date_category,
        crosshair: true
      })
      c.tooltip( {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            "<td style='padding:0'><b>{point.y} #{unit}</b></td></tr>",
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
      c.series(type: 'spline', name: '目標', data: [goal] * (range_size + 1),
               marker: {
                 lineWidth: 1,
                 lineColor: 'white',
                 fillColor: 'white'
               })
      c.series(name: '件数', data: learning_for_each_day)
      # c.series(name: 'ライバル1', data: days1)
      # c.series(name: 'ライバル2', data: days2)
    end
  end

  def review_chart(learning)
    review_data = [0, 100]
    decrease_speed = INITIAL_DECREASE_SPEED
    review_date_proficiency_map = set_review_date_proficiency(learning)
    range = chart_date_range(learning)
    if learning.created_at.to_date != Time.now.to_date
      (learning.created_at.to_date.tomorrow..Time.now.to_date).each do |date|
        if review_date_proficiency_map.keys.include?(date)
          review_data << 100
          decrease_speed = learning.calc_next_decrease_speed(decrease_speed, review_date_proficiency_map[date])
          next
        end
        last_data = review_data[-1] - decrease_speed
        last_data = 0 if last_data < 0
        review_data << last_data
      end
    end
    date_category = range.to_a.map{ |date| "#{date}日目" }
    text = review_text(review_data[-1])
    return generate_review_chart(learning.title, text, date_category, review_data)
  end

  def set_review_date_proficiency(learning)
    review_date_proficiency_map = {}
    learning.reviews.each do |review|
      review_date_proficiency_map[review.created_at.to_date] = review.proficiency
    end
    review_date_proficiency_map
  end

  def chart_date_range(learning)
    days_num = elapsed_days_num(learning)
    days_num > 10 ? 0..days_num : 0..10
  end

  def elapsed_days_num(learning)
    (Date.today - learning.created_at.to_date).to_i + 1
  end

  def review_text(point)
    return case point
    when 0..9
      'ヤバいよ'
    when 10..39
      '頑張ろう'
    when 40..69
      'そろそろ復習'
    else
      'イイ感じ'
    end
  end

  def generate_review_chart(title, text, date_category, review_data)
    LazyHighCharts::HighChart.new('graph') do |c|
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
      c.series(type: 'spline', name: title,
               data: review_data
      )
      c.chart(defaultSeriesType: "column")
      c.legend(maxHeight: 80)
      c.tooltip(shared: true,
                pointFormat: '<b>{point.y} %</b>',)
    end
  end
end
