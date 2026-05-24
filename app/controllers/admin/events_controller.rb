class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [ :edit, :update, :destroy ]

  def index
    @events = Event.order(starts_at: :desc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path, notice: "Veranstaltung wurde erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to admin_events_path, notice: "Veranstaltung wurde aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_events_path, notice: "Veranstaltung wurde gelöscht."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :event_type, :starts_at,
                                  :location, :ticket_url, :published, :image, :image_alt)
  end
end
