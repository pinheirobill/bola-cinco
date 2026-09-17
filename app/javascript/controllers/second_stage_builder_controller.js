import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "counter", "error", "submitButton", "groups", "candidate", "dropzone", "classificationView", "rankingView"]

  connect() {
    this.updateState()
  }

  updateState() {
    const selectedIds = this.selectTargets.map((select) => select.value).filter(Boolean)
    const uniqueIds = new Set(selectedIds)
    const hasDuplicates = uniqueIds.size !== selectedIds.length
    const complete = selectedIds.length > 0 && !hasDuplicates && this.selectTargets.every((select) => select.value)

    this.counterTarget.textContent = `${selectedIds.length} duplas selecionadas · ${this.groupsTarget.querySelectorAll(":scope > section").length} chave(s)`
    this.submitButtonTarget.disabled = !complete
    this.updateOptions(selectedIds)
    this.dropzoneTargets.forEach((dropzone) => {
      const select = this.selectTargets.find((item) => item.id === dropzone.dataset.selectId)
      const name = dropzone.querySelector("[data-dropzone-name]")
      const placeholder = dropzone.querySelector("[data-dropzone-placeholder]")
      const option = select?.selectedOptions[0]
      if (option?.value) {
        name.textContent = option.textContent
        name.classList.remove("hidden")
        placeholder.classList.add("hidden")
        this.applyGroupColor(dropzone, dropzone.dataset.groupKey)
      }
    })
    this.candidateTargets.forEach((candidate) => {
      const selected = selectedIds.includes(candidate.dataset.duplaId)
      candidate.classList.toggle("opacity-50", selected)
      candidate.classList.toggle("grayscale", selected)
      candidate.classList.toggle("cursor-not-allowed", selected)
      candidate.draggable = !selected
      candidate.setAttribute("aria-disabled", selected)
      if (selected) this.applyGroupColor(candidate, candidate.dataset.groupKey)
    })

    if (hasDuplicates) {
      this.errorTarget.textContent = "A mesma dupla não pode aparecer em mais de uma posição."
      this.errorTarget.classList.remove("hidden")
    } else {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.add("hidden")
    }
  }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", event.currentTarget.dataset.duplaId)
    event.dataTransfer.effectAllowed = "move"
  }

  allowDrop(event) {
    event.preventDefault()
    event.currentTarget.classList.add("border-primary", "bg-primary/10")
  }

  drop(event) {
    event.preventDefault()
    const dropzone = event.currentTarget
    const duplaId = event.dataTransfer.getData("text/plain")
    const select = this.selectTargets.find((item) => item.id === dropzone.dataset.selectId)
    const selectedIds = this.selectTargets.map((item) => item.value).filter(Boolean)
    if (!select || !duplaId) return
    if (selectedIds.includes(duplaId) && select.value !== duplaId) {
      this.errorTarget.textContent = "Essa dupla já está encaixada em outra posição."
      this.errorTarget.classList.remove("hidden")
      return
    }
    select.value = duplaId
    dropzone.querySelector("[data-dropzone-placeholder]").classList.add("hidden")
    const name = dropzone.querySelector("[data-dropzone-name]")
    name.textContent = this.candidateTargets.find((candidate) => candidate.dataset.duplaId === duplaId)?.dataset.duplaName || "Dupla selecionada"
    name.classList.remove("hidden")
    this.applyGroupColor(dropzone, dropzone.dataset.groupKey)
    dropzone.classList.remove("border-primary", "bg-primary/10")
    this.updateState()
  }

  addGroup() {
    const key = String.fromCharCode(65 + this.groupsTarget.querySelectorAll(":scope > section").length)
    const template = this.groupsTarget.querySelector("template")
    const wrapper = document.createElement("div")
    wrapper.innerHTML = template.innerHTML.replaceAll("__GROUP_KEY__", key).replaceAll("__SLOT_INDEX__", "0")
    this.groupsTarget.appendChild(wrapper.firstElementChild)
    this.updateState()
  }

  addSlot(event) {
    const section = event.currentTarget.closest("section")
    const template = section?.querySelector("template")
    if (!section || !template) return

    const groupKey = section.dataset.groupKey
    const slotIndex = section.querySelectorAll('[data-second-stage-builder-target="dropzone"]').length
    const wrapper = document.createElement("div")
    wrapper.innerHTML = template.innerHTML
      .replaceAll("__GROUP_KEY__", groupKey)
      .replaceAll("__SLOT_INDEX__", slotIndex)
      .replaceAll("__POSITION__", slotIndex + 1)
    section.querySelector("[data-slot-list]").appendChild(wrapper.firstElementChild)
    this.updateState()
  }

  toggleView(event) {
    const ranking = event.currentTarget.dataset.view === "ranking"
    this.classificationViewTarget.classList.toggle("hidden", ranking)
    this.rankingViewTarget.classList.toggle("hidden", !ranking)
    this.element.querySelectorAll("[data-view]").forEach((button) => {
      button.classList.toggle("btn-primary", button.dataset.view === (ranking ? "ranking" : "classification"))
    })
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

  applyGroupColor(element, groupKey) {
    const colors = {
      A: ["border-blue-400", "bg-blue-50"],
      B: ["border-emerald-400", "bg-emerald-50"],
      C: ["border-amber-400", "bg-amber-50"],
      D: ["border-violet-400", "bg-violet-50"]
    }
    Object.values(colors).flat().forEach((className) => element.classList.remove(className))
    const selectedColors = colors[groupKey]
    if (selectedColors) element.classList.add(...selectedColors)
  }
}
