class RequestProvider < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :provider_type, presence: true, inclusion: { in: %w[browser workstation api] }

  scope :active, -> { where(active: true) }
end
