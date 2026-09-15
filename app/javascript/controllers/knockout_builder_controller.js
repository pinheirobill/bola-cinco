import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "stepOne",
    "stepTwo",
    "stageSelect",
    "counter",
    "game",
    "select",
    "error",
    "submitButton"
  ]

  static values = {
    stageSlots: Object
  }

  connect() {
    this.showStep(1)
    this.updateStage()
  }

  next(event) {
    event.preventDefault()
    this.showStep(2)
    this.updateStage()

    requestAnimationFrame(() => {
      this.activeSelects[0]?.focus()
    })
  }

  back(event) {
    event.preventDefault()
    this.showStep(1)
    this.stageSelectTarget.focus()
  }

  updateStage() {
    const gameCount = this.requiredSlots / 2

    this.gameTargets.forEach((game, index) => {
      const active = index < gameCount
      game.classList.toggle("hidden", !active)

      game.querySelectorAll("select").forEach((select) => {
        select.disabled = !active
        if (!active) select.value = ""
      })
    })

    this.updateState()
  }

  updateState() {
    const selectedIds = this.activeSelects.map((select) => select.value).filter(Boolean)
    const uniqueIds = new Set(selectedIds)
    const hasDuplicates = uniqueIds.size !== selectedIds.length
    const complete = selectedIds.length === this.requiredSlots && !hasDuplicates

    this.counterTarget.textContent = `${selectedIds.length}/${this.requiredSlots} duplas selecionadas`
    this.submitButtonTarget.disabled = !complete

    if (hasDuplicates) {
      this.showError("A mesma dupla não pode aparecer duas vezes na chave eliminatória.")
    } else {
      this.hideError()
    }
  }

  get requiredSlots() {
    const stage = this.stageSelectTarget.value
    const slots = this.hasStageSlotsValue ? Number(this.stageSlotsValue[stage]) : 0

    return slots > 0 ? slots : 16
  }

  get activeSelects() {
    return this.selectTargets.filter((select) => !select.disabled)
  }

  showStep(step) {
    this.stepOneTarget.classList.toggle("hidden", step !== 1)
    this.stepTwoTarget.classList.toggle("hidden", step !== 2)
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("hidden")
  }

  hideError() {
    this.errorTarget.textContent = ""
    this.errorTarget.classList.add("hidden")
  }
}
