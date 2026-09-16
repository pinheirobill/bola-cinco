import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "counter", "error", "submitButton"]

  connect() {
    this.updateState()
  }

  updateState() {
    const selectedIds = this.selectTargets.map((select) => select.value).filter(Boolean)
    const uniqueIds = new Set(selectedIds)
    const hasDuplicates = uniqueIds.size !== selectedIds.length
    const complete = selectedIds.length === 16 && !hasDuplicates

    this.counterTarget.textContent = `${selectedIds.length}/16 duplas selecionadas`
    this.submitButtonTarget.disabled = !complete
    this.updateOptions(selectedIds)

    if (hasDuplicates) {
      this.errorTarget.textContent = "A mesma dupla não pode aparecer em mais de uma posição."
      this.errorTarget.classList.remove("hidden")
    } else {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.add("hidden")
    }
  }

  updateOptions(selectedIds) {
    this.selectTargets.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        option.disabled = option.value !== "" && option.value !== select.value && selectedIds.includes(option.value)
      })
    })
  }
}
