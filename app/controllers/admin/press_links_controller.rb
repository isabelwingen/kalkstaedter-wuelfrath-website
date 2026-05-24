class Admin::PressLinksController < Admin::BaseController
  before_action :set_press_link, only: [ :edit, :update, :destroy ]

  def index
    @press_links = PressLink.ordered
  end

  def new
    @press_link = PressLink.new
  end

  def create
    @press_link = PressLink.new(press_link_params)
    if @press_link.save
      redirect_to admin_press_links_path, notice: "Zeitungsartikel wurde erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @press_link.update(press_link_params)
      redirect_to admin_press_links_path, notice: "Zeitungsartikel wurde aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @press_link.destroy
    redirect_to admin_press_links_path, notice: "Zeitungsartikel wurde gelöscht."
  end

  private

  def set_press_link
    @press_link = PressLink.find(params[:id])
  end

  def press_link_params
    params.require(:press_link).permit(:title, :url, :publication, :published_on)
  end
end
