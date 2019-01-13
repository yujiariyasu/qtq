class Tag < ApplicationRecord
  has_many :learnings, through: :learning_tags
  has_many :learning_tags, dependent: :destroy
end
