class Admin::TextImprovementsController < Admin::BaseController
  def create
    text = params[:text].to_s.strip
    system_prompt = SiteSetting.get("ki_systemprompt").to_s
    improved = GeminiService.improve_text(text, system_prompt)
    render json: { text: improved }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
