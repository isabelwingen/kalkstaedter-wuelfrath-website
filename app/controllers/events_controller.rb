class EventsController < ApplicationController
  allow_unauthenticated_access

  def index
    @events = Event.published.upcoming
    @past_events = Event.published.past.limit(10)
  end

  def show
    @event = Event.published.find(params[:id])
  end
end
