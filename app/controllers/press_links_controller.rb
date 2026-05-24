class PressLinksController < ApplicationController
  allow_unauthenticated_access

  def index
    @press_links = PressLink.ordered
    @info_channels = InfoChannel.ordered
  end
end
