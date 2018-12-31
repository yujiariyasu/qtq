class Comment < ApplicationRecord
  has_many :comment_likes, dependent: :destroy
  belongs_to :learning
  belongs_to :user
end
