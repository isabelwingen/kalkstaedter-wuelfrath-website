module ApplicationHelper
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

  def event_type_label(event_type)
    { "auftritt" => "Auftritt", "party" => "Party", "sonstiges" => "Sonstiges" }[event_type] || event_type
  end

  def event_type_badge(event_type)
    content_tag(:span, event_type_label(event_type), class: "badge badge-#{event_type}")
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
