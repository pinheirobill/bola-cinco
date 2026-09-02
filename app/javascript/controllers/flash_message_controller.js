import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    const message = event.detail?.message
    if (!message) return

    const variant = event.detail?.variant === "error" ? "error" : "success"
    const alert = document.createElement("div")
    alert.className = `alert alert-${variant} shadow-sm transition-opacity duration-200 pointer-events-auto`
    alert.setAttribute("role", variant === "error" ? "alert" : "status")
    alert.innerHTML = `
      <span class="min-w-0 break-words">${message}</span>
      <button type="button" class="btn btn-ghost btn-xs" aria-label="Fechar aviso">Fechar</button>
    `

    alert.querySelector("button")?.addEventListener("click", () => this.dismiss(alert))
    this.element.appendChild(alert)

    window.setTimeout(() => this.dismiss(alert), 3500)
  }

  dismiss(alert) {
    if (!alert || !alert.isConnected) return

    alert.classList.add("opacity-0", "pointer-events-none")
    window.setTimeout(() => alert.remove(), 200)
  }
}
