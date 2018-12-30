class LearningLike < ApplicationRecord
  belongs_to :user
  belongs_to :learning, counter_cache: :likes_count
end
