module Chart
  extend ActiveSupport::Concern

  def schedule_chart(user)
    days_until_review_hash = Hash.new(0)
    review_detail_data = Hash.new { |h, k| h[k] = [] }
    user.learnings.not_finished.each do |learning|
      learning.set_review_data(review_detail_data, days_until_review_hash)
    end
    text = days_until_review_hash[:today] == 0 ? '今日の復習はありません。' :
      "復習で学習を定着させましょう!!"
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
              name: "今日：#{days_until_review_hash[:today]}分",
              y: days_until_review_hash[:today],
              drilldown: '今日'
          },
          {
              name: "明日：#{days_until_review_hash[:tomorrow]}分",
              y: days_until_review_hash[:tomorrow],
              drilldown: '明日'
          },
          {
              name: "あさって：#{days_until_review_hash[:two_days_later]}分",
              y: days_until_review_hash[:two_days_later],
              drilldown: 'あさって'
          },
          {
              name: "しあさって：#{days_until_review_hash[:three_days_later]}分",
              y: days_until_review_hash[:three_days_later],
              drilldown: 'しあさって'
          },
          {
              name: "4日後〜1ヶ月後：#{days_until_review_hash[:four_days_later]}分",
              y: days_until_review_hash[:four_days_later],
              drilldown: '4日後〜1ヶ月後'
          },
          {
              name: "1ヶ月後以降：#{days_until_review_hash[:one_month_later]}分",
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

  def generate_review_chart(text, date_category, review_data)
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
