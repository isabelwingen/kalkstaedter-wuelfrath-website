class Event < ApplicationRecord
  has_one_attached :image

  enum :event_type, { auftritt: "auftritt", party: "party", sonstiges: "sonstiges" }

  validates :title, presence: true
  validates :starts_at, presence: true
  validates :event_type, presence: true

  scope :published, -> { where(published: true) }
  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }
  scope :past, -> { where("starts_at < ?", Time.current).order(starts_at: :desc) }
end
