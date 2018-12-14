class Review < ApplicationRecord
  belongs_to :learning

  def first_in_the_day?
    Review.where(created_at: created_at.midnight..created_at.end_of_day, learning_id: learning_id).count == 1
  end
end
