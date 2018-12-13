class Review < ApplicationRecord
  belongs_to :learning

  def first_in_the_day?
    Review.where(created_at: created_at.strftime('%Y-%m-%d 00:00:00')..created_at.strftime('%Y-%m-%d 23:59:59'), learning_id: learning_id).count == 1
  end
end
