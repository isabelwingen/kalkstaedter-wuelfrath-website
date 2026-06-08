class Admin::StaticPagesController < Admin::BaseController
  before_action :set_page, only: %i[edit update]

  def index
    records = StaticPageContent.where(slug: StaticPageContent::SLUGS).index_by(&:slug)
    @pages = StaticPageContent::SLUGS.map do |slug|
      { slug: slug, title: StaticPageContent::TITLES[slug], record: records[slug] }
    end
  end

  def edit; end

  def update
    if @page.update(content: page_params[:content])
      redirect_to admin_static_pages_path, notice: "\"#{@page_title}\" wurde gespeichert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    slug = params[:id]
    unless StaticPageContent::TITLES.key?(slug)
      redirect_to admin_static_pages_path, alert: "Unbekannte Seite."
      return
    end
    @slug = slug
    @page_title = StaticPageContent::TITLES[slug]
    @page = StaticPageContent.find_or_initialize_by(slug: slug)
  end

  def page_params
    params.require(:static_page_content).permit(:content)
  end
end
