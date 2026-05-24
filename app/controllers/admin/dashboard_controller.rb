class Admin::DashboardController < Admin::BaseController
  def index
    @events_count = Event.count
    @posts_count = Post.count
    @press_links_count = PressLink.count
  end
end
