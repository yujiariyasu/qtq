class Learning < ApplicationRecord
  include Chart

  has_many :reviews, dependent: :destroy
  belongs_to :user

  mount_uploaders :images, AvatarUploader
  validates :title, presence: true, length: { maximum: 50 }

  scope :not_finished, -> { where(finish_flag: false) }

  INITIAL_DECREASE_SPEED = 67
  REVIEW_NOTIFICATION_LINE = 51

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
    return generate_review_chart(text, date_category, review_data)
  end

  def calc_next_decrease_speed(decrease_speed, proficiency)
    speed = decrease_speed / proficiency == 100 ? 6 : (1 + proficiency * 2 / 100)
    return speed == 0 ? 1 : speed
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

  def update_next_review_date_and_speed(proficiency)
    params = {}
    params[:proficiency_decrease_speed] = calc_next_decrease_speed(proficiency_decrease_speed ,proficiency)
    days_until_review = REVIEW_NOTIFICATION_LINE / proficiency_decrease_speed + 1
    params[:next_review_date] = next_review_date + days_until_review
    self.update_attributes(params)
  end

  def set_review_data(review_detail_data, days_until_review_hash, unit)
    days_until_review = (next_review_date - Time.current.to_date).to_i
    time = study_time
    case days_until_review
    when 1
      review_detail_data[:tomorrow] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:tomorrow] += time
    when 2
      review_detail_data[:two_days_later] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:two_days_later] += time
    when 3
      review_detail_data[:three_days_later] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:three_days_later] += time
    when 4..30
      review_detail_data[:four_days_later] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:four_days_later] += time
    when (31..Float::INFINITY)
      review_detail_data[:one_month_later] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:one_month_later] += time
    else
      review_detail_data[:today] << ["#{title}：#{time}#{unit}", time]
      days_until_review_hash[:today] += time
    end
  end
end
