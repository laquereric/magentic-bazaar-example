class ResponseMiddleware < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :middleware_type, presence: true, inclusion: { in: %w[authentication validation enrichment] }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position) }
end
