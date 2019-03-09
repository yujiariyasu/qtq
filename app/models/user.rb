# tewet
class User < ApplicationRecord
  has_many :active_relationships, class_name: 'UserRelationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'UserRelationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :learnings, dependent: :destroy
  has_many :learning_likes, dependent: :destroy
  has_many :comments
  has_many :subscriptions
  has_many :active_activities, class_name: 'Activity', foreign_key: 'active_user_id'
  has_many :passive_activities, class_name: 'Activity', foreign_key: 'passive_user_id'
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  mount_uploader :avatar, AvatarUploader
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true, ban_reserved: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password(validations: false)
  validates :password, length: (6..32), presence: true, confirmation: true, allow_blank: true
  validates :password, presence: false, on: :facebook_login
# test
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
# test33333

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def self.from_omniauth(auth)
    user = User.find_by(uid: auth.uid) || User.new
    user.provider = auth.provider
    user.uid = auth.uid
    user.name ||= auth.info.name
    user.email ||= auth.info.email
    user.remote_avatar_url ||= auth.info.image.gsub('http', 'https')
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.goal ||= 5
    user
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def learning_for_each_day(range)
    study_times = {}
    range.each do |date|
      study_times[date] = 0
    end
    learnings.where(created_at: range.first.strftime('%Y-%m-%d 00:00:00')..range.last.strftime('%Y-%m-%d 23:59:59')).each do |learning|
      study_times[learning.created_at.to_date] += 1
    end
    study_times.values
  end

  def number_of_learnings(range_last_date, date_range_num)
    learnings.where(created_at: (range_last_date - date_range_num).midnight..range_last_date.end_of_day).count
  end

  def likes_learning?(learning)
    LearningLike.find_by(user: self, learning: learning)
  end

  def likes_comment?(comment)
    CommentLike.find_by(user: self, comment: comment)
  end

  def webpush
    learnings_count = learnings.where(next_review_date: '2019-01-01'.to_date..Date.current).not_finished.count
    return if learnings_count == 0
    message = {
        # tag: Time.current.strftime('%Y-%m-%d'), # 一日複数回送るかもなので一旦コメントアウト
        title: 'QtQ からメッセージ',
        body: "今日の復習は#{learnings_count}件です",
        icon: ActionController::Base.helpers.asset_path('webpush-logo.png')
    }
    subscriptions.each do |subscription|
      begin
        Webpush.payload_send(
            message: JSON.generate(message),
            endpoint: subscription.endpoint,
            p256dh: subscription.p256dh,
            auth: subscription.auth,
            vapid: {
                subject: "mailto:#{ENV['MAIL']}",
                public_key: ENV['WEB_PUSH_VAPID_PUBLIC_KEY'],
                private_key: ENV['WEB_PUSH_VAPID_PRIVATE_KEY'],
                expiration: 12 * 60 * 60
            }
        )
      rescue Webpush::InvalidSubscription => e
        logger.error e
        subscription.destroy
      end
    end
  end
# test22
  private
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
