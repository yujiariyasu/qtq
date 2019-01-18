class Learning < ApplicationRecord
  include Chart

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :learning_likes
  has_many :learning_likes, dependent: :destroy
  has_many :tags, through: :learning_tags
  has_many :learning_tags, dependent: :destroy
  mount_uploaders :images, AvatarUploader
  validates :title, presence: true, length: { maximum: 50 }, allow_blank: true

  scope :not_finished, -> { where(finish_flag: false) }
  scope :review_today, -> { where(next_review_date: '2019-01-01'.to_date..Date.current) }
  scope :searched_by, ->(word) { where('title LIKE(?)', "%#{word}%") }

  INITIAL_DECREASE_SPEED = 67
  REVIEW_NOTIFICATION_LINE = 51

  def calc_next_decrease_speed(decrease_speed, proficiency)
    divider = proficiency == 100 ? 6 : 1 + proficiency * 2 / 100.0
    speed = decrease_speed / divider
    return speed == 0 ? 1 : speed.round(0)
  end

  def update_with_review(proficiency, review_description, first_in_the_day_flag)
    update_params = {}
    if first_in_the_day_flag
      update_params[:proficiency_decrease_speed] = calc_next_decrease_speed(proficiency_decrease_speed, proficiency)
      days_until_review = REVIEW_NOTIFICATION_LINE / proficiency_decrease_speed + 1
      update_params[:next_review_date] = next_review_date + days_until_review
    end
    update_params[:proficiency] = proficiency
    update_params[:description] = add_review_description(review_description) if review_description.present?
    self.update_attributes(update_params)
  end

  def add_review_description(review_description)
    prefix = "\n***\n[復習メモ]\n"
    description + prefix + review_description
  end

  def like_user(user_id)
   likes.find_by(user_id: user_id)
  end

  def save_tags(tag_names)
    current_tag_names = tags.present? ? tags.pluck(:name) : []
    old_tag_names = current_tag_names - tag_names
    new_tag_names = tag_names - current_tag_names

    old_tag_names.each do |old_name|
      tags.delete(Tag.find_by(name: old_name))
    end

    new_tag_names.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
end
