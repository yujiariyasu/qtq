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
    divider = proficiency == 100 ? 6 : 1 + proficiency * 2 / 100.0
    speed = decrease_speed / divider
    return speed == 0 ? 1 : speed.round(0)
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

  def update_with_review(proficiency, review_description, first_in_the_day_flag)
    params = {}
    if first_in_the_day_flag
      params[:proficiency_decrease_speed] = calc_next_decrease_speed(proficiency_decrease_speed, proficiency)
      days_until_review = REVIEW_NOTIFICATION_LINE / proficiency_decrease_speed + 1
      params[:next_review_date] = next_review_date + days_until_review
    end
    params[:description] = add_review_description(review_description) if review_description.present?
    self.update_attributes(params)
  end

  def add_review_description(review_description)
    prefix = "\n***\n[復習メモ]\n"
    description + prefix + review_description
  end
end
