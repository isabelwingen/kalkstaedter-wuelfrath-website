class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @upcoming_events = Event.published.upcoming.limit(3)
    @recent_posts = Post.published.limit(3)
  end
end
