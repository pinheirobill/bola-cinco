import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "counter", "error", "submitButton", "groups"]

  connect() {
    this.updateState()
  }

  updateState() {
    const selectedIds = this.selectTargets.map((select) => select.value).filter(Boolean)
    const uniqueIds = new Set(selectedIds)
    const hasDuplicates = uniqueIds.size !== selectedIds.length
    const complete = selectedIds.length > 0 && selectedIds.length % 4 === 0 && !hasDuplicates && this.selectTargets.every((select) => select.value)

    this.counterTarget.textContent = `${selectedIds.length} duplas selecionadas · ${this.groupsTarget.querySelectorAll(":scope > section").length} chave(s)`
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

  addGroup() {
    const key = String.fromCharCode(65 + this.groupsTarget.querySelectorAll(":scope > section").length)
    const template = this.groupsTarget.querySelector("template")
    const wrapper = document.createElement("div")
    wrapper.innerHTML = template.innerHTML.replaceAll("__GROUP_KEY__", key)
    this.groupsTarget.appendChild(wrapper.firstElementChild)
    this.updateState()
  }

  removeGroup(event) {
    if (this.groupsTarget.querySelectorAll(":scope > section").length <= 1) return
    event.currentTarget.closest("section").remove()
    this.updateState()
  }

  updateOptions(selectedIds) {
    this.selectTargets.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        option.disabled = option.value !== "" && option.value !== select.value && selectedIds.includes(option.value)
      })
    })
  }
}
