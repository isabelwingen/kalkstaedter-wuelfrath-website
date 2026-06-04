import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button"]

  async improve() {
    const text = this.sourceTarget.value.trim()
    if (!text) return

    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "Wird verbessert\u2026"

    try {
      const response = await fetch("/admin/text_improvements", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
        },
        body: JSON.stringify({ text })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "Unbekannter Fehler")
      }

      this.sourceTarget.value = data.text
    } catch (e) {
      alert("KI-Verbesserung fehlgeschlagen: " + e.message)
    } finally {
      this.buttonTarget.disabled = false
      this.buttonTarget.textContent = "Mit KI verbessern"
    }
  }
}
