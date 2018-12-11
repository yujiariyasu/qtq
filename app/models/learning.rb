class Learning < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  mount_uploaders :images, AvatarUploader
  validates :title, presence: true, length: { maximum: 50 }

  INITIAL_DECREASE_SPEED = 67
  REVIEW_NOTIFICATION_LINE = 50

  def review_chart
    review_data = [0, 100]
    decrease_speed = INITIAL_DECREASE_SPEED
    review_date_proficiency_map = set_review_date_proficiency
    range = chart_date_range(review_date_proficiency_map)
    if created_at.to_date != Time.now.to_date
      (created_at.to_date.tomorrow..Time.now.to_date).each do |date|
        if review_date_proficiency_map.keys.include?(date)
          review_data << 100
          decrease_speed = calc_next_decrease_speed(decrease_speed, review_date_proficiency_map[date])
          next
        end
        last_data = review_data[-1] - decrease_speed
        last_data = 0 if last_data < 0
        review_data << last_data
      end
    end
    date_category = range.to_a.map{ |date| "#{date}日目" }
    text = review_text(review_data[-1])
    return generate_chart(text, date_category, review_data)
  end

  def calc_next_decrease_speed(decrease_speed, proficiency)
    decrease_speed / proficiency == 100 ? 6 : (1 + proficiency * 2 / 100)
  end

  def generate_chart(text, date_category, review_data)
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

  def chart_date_range(review_date_proficiency_map)
    days_num = review_date_proficiency_map.present? ? elapsed_days_num : 1
    days_num > 10 ? 0..elapsed_days_num : 0..10
  end

  def set_review_date_proficiency
    review_date_proficiency_map = {}
    reviews.each do |review|
      review_date_proficiency_map[review.created_at.to_date] = review.proficiency
    end
    review_date_proficiency_map
  end

  def elapsed_days_num
    (reviews.order('created_at desc').first.created_at.to_date - created_at.to_date).to_i + 1
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
end
