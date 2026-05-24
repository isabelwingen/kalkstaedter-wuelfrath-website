class Admin::InfoChannelsController < Admin::BaseController
  before_action :set_info_channel, only: [ :edit, :update, :destroy ]

  def index
    @info_channels = InfoChannel.ordered
  end

  def new
    @info_channel = InfoChannel.new
  end

  def create
    @info_channel = InfoChannel.new(info_channel_params)
    if @info_channel.save
      redirect_to admin_info_channels_path, notice: "Info-Kanal wurde erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @info_channel.update(info_channel_params)
      redirect_to admin_info_channels_path, notice: "Info-Kanal wurde aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @info_channel.destroy
    redirect_to admin_info_channels_path, notice: "Info-Kanal wurde gelöscht."
  end

  private

  def set_info_channel
    @info_channel = InfoChannel.find(params[:id])
  end

  def info_channel_params
    params.require(:info_channel).permit(:name, :url, :platform)
  end
end
