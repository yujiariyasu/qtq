class Learning < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
end
