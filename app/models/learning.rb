class Learning < ApplicationRecord
  include Chart

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :learning_likes
  has_many :learning_likes, dependent: :destroy
  has_many :tags, through: :learning_tags
  has_many :learning_tags, dependent: :destroy
  has_many :activities, dependent: :destroy
  mount_uploaders :images, AvatarUploader
  validates :title, presence: true, length: { maximum: 250 }, allow_blank: true

  scope :not_finished, -> { where(finished: false) }
  scope :review_today, -> { where(next_review_date: '2019-01-01'.to_date..Date.current).not_finished }
  scope :searched_by, ->(word) { where('title LIKE(?)', "%#{word}%").or(Learning.where('description LIKE(?)', "%#{word}%")) }
  scope :searched_by_tag, lambda { |word|
    where(id: LearningTag.where(tag_id: Tag.where('name LIKE(?)', "%#{word}%").pluck(:id)).pluck(:learning_id))
  }
  scope :liked_by, ->(user) { where(id: user.learning_likes.pluck(:learning_id)) }

  INITIAL_DECREASE_SPEED = 67
  REVIEW_NOTIFICATION_LINE = 51

  def calc_next_decrease_speed(decrease_speed, proficiency)
    divider = proficiency == 100 ? 6 : 1 + proficiency * 2 / 100.0
    speed = decrease_speed / divider
    return speed < 1 ? 1 : speed.round(0)
  end

  def update_with_review(is_finish, proficiency, review_description, first_review_in_the_day)
    update_params = {}
    if first_review_in_the_day
      update_params[:proficiency_decrease_speed] = calc_next_decrease_speed(proficiency_decrease_speed, proficiency)
      days_until_review = REVIEW_NOTIFICATION_LINE / update_params[:proficiency_decrease_speed] + 1
      update_params[:next_review_date] = Date.current + days_until_review
    end
    update_params[:proficiency] = proficiency
    if !finished && update_params[:finished] = is_finish
      update_params[:finish_date] = Date.current
    end
    update_params[:description] = add_review_description(review_description) if review_description.present?
    self.update(update_params)
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
