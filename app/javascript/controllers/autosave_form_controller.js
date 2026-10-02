import { Controller } from "@hotwired/stimulus"

const INPUT_DELAY_MS = 600

export default class extends Controller {
  static values = { debug: Boolean }
  static targets = ["flag", "status"]

  connect() {
    this.timeout = null
    this.submitting = false
    this.needsSubmit = false
    this.statusTimeout = null
    this.lastSnapshot = this.snapshot()
    this.log("connected", { method: this.element.method, action: this.element.action })
  }

  disconnect() {
    this.clearTimer()
    this.clearStatusTimer()
  }

  queue(event) {
    if (!this.hasChanged()) {
      this.log("change ignored", { event: event?.type, reason: "unchanged" })
      return
    }

    if (this.submitting) {
      this.needsSubmit = true
      this.log("change queued", { event: event?.type, reason: "submit in progress" })
      return
    }

    this.clearTimer()

    const delay = event?.type === "input" ? INPUT_DELAY_MS : 0
    this.log("save queued", { event: event?.type, delay })
    this.timeout = window.setTimeout(() => this.submit(), delay)
  }

  submit() {
    if (!this.hasChanged() || this.submitting) return

    if (!this.element.checkValidity()) {
      this.needsSubmit = false
      this.log("submit blocked", {
        invalidFields: Array.from(this.element.elements)
          .filter((field) => typeof field.checkValidity === "function" && !field.checkValidity())
          .map((field) => ({ name: field.name, message: field.validationMessage }))
      })
      return
    }

    this.showStatus("Salvando...", "alert-info")
    this.submitting = true
    this.submittedSnapshot = this.snapshot()
    if (this.hasFlagTarget) this.flagTarget.disabled = false
    this.log("submitting", {
      method: this.element.method,
      action: this.element.action,
      autosaveFlagEnabled: this.hasFlagTarget && !this.flagTarget.disabled
    })
    this.element.requestSubmit()
  }

  log(message, details = {}) {
    if (this.hasDebugValue && this.debugValue) {
      console.info(`[autosave-form] ${message}`, details)
    }
  }

  complete(event) {
    this.submitting = false
    if (this.hasFlagTarget) this.flagTarget.disabled = true
    this.log("request completed", {
      success: event.detail.success,
      status: event.detail.fetchResponse?.response?.status
    })

    if (event.detail.success) {
      this.lastSnapshot = this.submittedSnapshot
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
    const formData = new FormData(this.element)
    formData.delete("autosave")
    return new URLSearchParams(formData).toString()
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
