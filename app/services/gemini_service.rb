class GeminiService
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent"

  def self.improve_text(text, system_prompt)
    uri = URI("#{API_URL}?key=#{ENV.fetch("GEMINI_API_KEY")}")

    body = {
      system_instruction: { parts: [ { text: system_prompt } ] },
      contents: [ { parts: [ { text: text } ] } ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 30

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = body.to_json

    response = http.request(request)
    data = JSON.parse(response.body)

    unless response.is_a?(Net::HTTPSuccess)
      error_msg = data.dig("error", "message") || response.body[0..300]
      raise("Gemini API Fehler (#{response.code}): #{error_msg}")
    end

    data.dig("candidates", 0, "content", "parts", 0, "text") || raise("Keine Antwort von Gemini: #{data.inspect[0..300]}")
  end
end
