class StaticPageContent < ApplicationRecord
  SLUGS = %w[ueber_uns mitmachen musikschule chronik impressum datenschutz].freeze

  TITLES = {
    "ueber_uns"   => "Über uns",
    "mitmachen"   => "Mitmachen",
    "musikschule" => "Musikschule",
    "chronik"     => "Chronik",
    "impressum"   => "Impressum",
    "datenschutz" => "Datenschutz"
  }.freeze

  validates :slug, presence: true, uniqueness: true, inclusion: { in: SLUGS }
  validates :content, presence: true
end
