module ApplicationHelper
  PAGE_CONTENT_ALLOWED_TAGS = %w[
    h1 h2 h3 h4 h5 h6
    p br hr
    strong em s
    ul ol li
    blockquote pre code
    a
    table thead tbody tr th td
  ].freeze

  PAGE_CONTENT_ALLOWED_ATTRS = %w[href target rel colspan rowspan].freeze

  def sanitize_page_content(html)
    sanitize(html, tags: PAGE_CONTENT_ALLOWED_TAGS, attributes: PAGE_CONTENT_ALLOWED_ATTRS)
  end

  def nav_link_class(path)
    current_page?(path) ? "active" : ""
  end

  def aria_current_page(path)
    return "page" if current_page?(path)
    return "page" if path != root_path && request.path.start_with?(path)

    nil
  end

  def admin_nav_class(path)
    request.path.start_with?(path) ? "active" : ""
  end

  def event_type_badge(event_type)
    label = { "auftritt" => "Auftritt", "party" => "Party", "sonstiges" => "Sonstiges" }[event_type] || event_type
    content_tag(:span, label, class: "badge badge-#{event_type}")
  end

  def platform_icon(platform)
    icons = {
      "instagram" => "📸",
      "facebook"  => "👥",
      "whatsapp"  => "💬",
      "youtube"   => "▶️",
      "sonstiges" => "🔗"
    }
    icons[platform] || "🔗"
  end

  def platform_label(platform)
    { "instagram" => "Instagram", "facebook" => "Facebook",
      "whatsapp" => "WhatsApp", "youtube" => "YouTube", "sonstiges" => "Sonstiges" }[platform] || platform
  end
end
