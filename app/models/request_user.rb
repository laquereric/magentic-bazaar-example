class RequestUser < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: %w[individual group] }

  scope :active, -> { where(active: true) }
end
