class Post < ApplicationRecord
  belongs_to :event, optional: true
  has_one_attached :image

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true).order(published_at: :desc) }
end
