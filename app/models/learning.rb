class Learning < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  mount_uploaders :images, AvatarUploader
  validates :title, presence: true, length: { maximum: 50 }
end
