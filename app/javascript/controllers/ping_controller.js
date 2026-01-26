import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result"]

  get apiBaseUrl() {
    return document.querySelector('meta[name="api-base-url"]')?.content || ""
  }

  async ping() {
    this.resultTarget.textContent = "..."

    try {
      const response = await fetch(`${this.apiBaseUrl}/ping`)
      const data = await response.json()
      this.resultTarget.textContent = `${data.message} @ ${new Date(data.timestamp).toLocaleTimeString()}`
    } catch (error) {
      this.resultTarget.textContent = `Error: ${error.message}`
    }
  }
}
