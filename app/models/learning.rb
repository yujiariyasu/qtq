class Learning < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  def elapsed_days_num
    (created_at.to_date - reviews.order('date DESC').first.created_at.to_date).to_i
  end
end
