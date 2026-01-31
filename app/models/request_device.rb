class RequestDevice < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :device_type, presence: true, inclusion: { in: %w[phone laptop server] }

  scope :active, -> { where(active: true) }
end
