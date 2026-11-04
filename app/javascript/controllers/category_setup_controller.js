import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rows", "template"]
  static values = { nextIndex: Number }

  add() {
    const row = this.templateTarget.content.cloneNode(true)
    const index = this.nextIndexValue
    row.querySelectorAll("[name], [id], label[for], [aria-label]").forEach((element) => {
      ;["name", "id", "for", "aria-label"].forEach((attribute) => {
        const value = element.getAttribute(attribute)
        if (value) element.setAttribute(attribute, value.replaceAll("NEW_RECORD", index))
      })
    })
    const rowTitle = row.querySelector("[data-category-setup-row-title]")
    if (rowTitle) rowTitle.textContent = `Categoria ${index + 1}`
    const rowLegend = row.querySelector("legend")
    if (rowLegend) rowLegend.textContent = `Categoria ${index + 1}`
    const removeButton = row.querySelector("[data-category-setup-remove]")
    if (removeButton) removeButton.setAttribute("aria-label", `Remover categoria ${index + 1}`)
    this.rowsTarget.append(row)
    this.nextIndexValue = index + 1
  }

  remove(event) {
    event.preventDefault()
    const row = event.currentTarget.closest("[data-category-setup-row]")
    row?.remove()
  }
}
