class Learning < ApplicationRecord
  has_many :reviews, dependent: :destroy
end
