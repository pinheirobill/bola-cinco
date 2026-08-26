import { Controller } from "@hotwired/stimulus"

const INPUT_DELAY_MS = 600

export default class extends Controller {
  static targets = ["flag", "status"]

  connect() {
    this.timeout = null
    this.submitting = false
    this.needsSubmit = false
    this.statusTimeout = null
    this.lastSnapshot = this.snapshot()
  }

  disconnect() {
    this.clearTimer()
    this.clearStatusTimer()
  }

  queue(event) {
    if (!this.hasChanged()) return

    if (this.submitting) {
      this.needsSubmit = true
      return
    }

    this.clearTimer()

    const delay = event?.type === "input" ? INPUT_DELAY_MS : 0
    this.timeout = window.setTimeout(() => this.submit(), delay)
  }

  submit() {
    if (!this.hasChanged() || this.submitting) return

    if (!this.element.checkValidity()) {
      this.needsSubmit = false
      return
    }

    this.showStatus("Salvando...", "alert-info")
    this.submitting = true
    if (this.hasFlagTarget) this.flagTarget.disabled = false
    this.element.requestSubmit()
  }

  complete(event) {
    this.submitting = false
    if (this.hasFlagTarget) this.flagTarget.disabled = true

    if (event.detail.success) {
      this.lastSnapshot = this.snapshot()
      this.showStatus("Salvo", "alert-success", 900)
    } else {
      this.showStatus("Erro ao salvar", "alert-error", 1400)
    }

    if (event.detail.success && this.needsSubmit && this.hasChanged()) {
      this.needsSubmit = false
      this.queue({ type: "change" })
      return
    }

    this.needsSubmit = false
  }

  hasChanged() {
    return this.snapshot() !== this.lastSnapshot
  }

  snapshot() {
    return new URLSearchParams(new FormData(this.element)).toString()
  }

  clearTimer() {
    if (this.timeout) window.clearTimeout(this.timeout)
    this.timeout = null
  }

  showStatus(message, variant, autoHideAfter = 0) {
    if (!this.hasStatusTarget) return

    this.clearStatusTimer()
    this.statusTarget.textContent = message
    this.statusTarget.dataset.variant = variant
    this.statusTarget.classList.remove("hidden")
    this.statusTarget.classList.remove("alert-info", "alert-success", "alert-error")
    this.statusTarget.classList.add(variant)

    if (autoHideAfter > 0) {
      this.statusTimeout = window.setTimeout(() => this.hideStatus(), autoHideAfter)
    }
  }

  hideStatus() {
    if (!this.hasStatusTarget) return

    this.statusTarget.classList.add("hidden")
  }

  clearStatusTimer() {
    if (this.statusTimeout) window.clearTimeout(this.statusTimeout)
    this.statusTimeout = null
  }
}
