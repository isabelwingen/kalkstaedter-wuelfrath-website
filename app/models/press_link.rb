class PressLink < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true

  scope :ordered, -> { order(published_on: :desc) }
end
