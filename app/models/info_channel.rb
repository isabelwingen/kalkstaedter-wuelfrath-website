class InfoChannel < ApplicationRecord
  enum :platform, {
    instagram: "instagram",
    facebook: "facebook",
    whatsapp: "whatsapp",
    youtube: "youtube",
    sonstiges: "sonstiges"
  }

  validates :name, presence: true
  validates :url, presence: true
  validates :platform, presence: true

  scope :ordered, -> { order(:name) }
end
