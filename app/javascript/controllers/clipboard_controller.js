import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async copy(event) {
    const value = event.currentTarget.dataset.clipboardValue
    if (!value) return

    try {
      await this.writeToClipboard(value)
      this.dispatch("copied", { detail: { message: "Link copiado" } })
    } catch (_error) {
      this.dispatch("copied", { detail: { message: "Não foi possível copiar o link", variant: "error" } })
    }
  }

  async writeToClipboard(value) {
    if (navigator.clipboard?.writeText) {
      return navigator.clipboard.writeText(value)
    }

    const textarea = document.createElement("textarea")
    textarea.value = value
    textarea.setAttribute("readonly", "")
    textarea.style.position = "fixed"
    textarea.style.opacity = "0"
    document.body.appendChild(textarea)
    textarea.select()

    const success = document.execCommand("copy")
    document.body.removeChild(textarea)

    if (!success) {
      throw new Error("copy failed")
    }
  }
}
