class Activity < ApplicationRecord
  belongs_to :active_user, class_name: 'User', foreign_key: 'active_user_id'
  belongs_to :passive_user, class_name: 'User', foreign_key: 'passive_user_id'
  belongs_to :learning

  scope :not_checked, -> { where(checked: false) }
end
