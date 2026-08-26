import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = window.setTimeout(() => this.dismiss(), 6000)
  }

  disconnect() {
    window.clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "pointer-events-none")
    window.setTimeout(() => this.element.remove(), 200)
  }
}
