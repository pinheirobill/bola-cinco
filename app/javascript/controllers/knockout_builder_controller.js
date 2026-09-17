import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "stepOne",
    "stepTwo",
    "stageSelect",
    "counter",
    "game",
    "slot",
    "candidate",
    "hiddenInput",
    "error",
    "submitButton",
    "classificationView",
    "rankingView"
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
      this.activeSlots[0]?.focus()
    })
  }

  back(event) {
    event.preventDefault()
    this.showStep(1)
    this.stageSelectTarget.focus()
  }

  toggleRanking(event) {
    event.preventDefault()
    const ranking = event.currentTarget.dataset.view === "ranking"
    this.classificationViewTarget.classList.toggle("hidden", ranking)
    this.rankingViewTarget.classList.toggle("hidden", !ranking)
  }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", event.currentTarget.dataset.duplaId)
    event.dataTransfer.effectAllowed = "move"
  }

  allowDrop(event) {
    event.preventDefault()
    event.currentTarget.classList.add("border-primary", "bg-primary/10")
  }

  leaveDrop(event) {
    event.currentTarget.classList.remove("border-primary", "bg-primary/10")
  }

  remove(event) {
    event.preventDefault()
    event.stopPropagation()

    const slot = event.currentTarget.closest("[data-knockout-builder-target='slot']")
    if (!slot) return

    slot.dataset.duplaId = ""
    slot.querySelector("[data-slot-placeholder]").classList.remove("hidden")
    slot.querySelector("[data-slot-name]").textContent = ""
    slot.querySelector("[data-slot-name]").classList.add("hidden")
    slot.querySelector("[data-slot-remove]").classList.add("hidden")

    const input = this.hiddenInputTargets.find((candidate) => candidate.dataset.slotId === slot.dataset.slotId)
    if (input) input.value = ""

    this.updateState()
  }

  drop(event) {
    event.preventDefault()
    const slot = event.currentTarget
    const duplaId = event.dataTransfer.getData("text/plain")
    const occupiedIds = this.activeHiddenInputs.map((input) => input.value).filter(Boolean)
    const previousId = slot.dataset.duplaId

    this.leaveDrop(event)
    if (!duplaId || (occupiedIds.includes(duplaId) && duplaId !== previousId)) {
      this.showError("Essa dupla já está encaixada em outro jogo.")
      return
    }

    slot.dataset.duplaId = duplaId
    slot.querySelector("[data-slot-placeholder]").classList.add("hidden")
    const name = slot.querySelector("[data-slot-name]")
    name.textContent = this.candidateName(duplaId)
    name.classList.remove("hidden")
    slot.querySelector("[data-slot-remove]").classList.remove("hidden")
    this.hiddenInputTargets.find((input) => input.dataset.slotId === slot.dataset.slotId).value = duplaId
    this.updateState()
  }

  updateStage() {
    const gameCount = this.requiredSlots / 2

    this.gameTargets.forEach((game, index) => {
      const active = index < gameCount
      game.classList.toggle("hidden", !active)

      game.querySelectorAll("input").forEach((input) => {
        input.disabled = !active
        if (!active) input.value = ""
      })
    })

    this.updateState()
  }

  updateState() {
    const selectedIds = this.activeHiddenInputs.map((input) => input.value).filter(Boolean)
    const uniqueIds = new Set(selectedIds)
    const hasDuplicates = uniqueIds.size !== selectedIds.length
    const complete = selectedIds.length === this.requiredSlots && !hasDuplicates

    this.counterTarget.textContent = `${selectedIds.length}/${this.requiredSlots} duplas selecionadas`
    this.submitButtonTarget.disabled = !complete
    this.candidateTargets.forEach((candidate) => {
      const selected = selectedIds.includes(candidate.dataset.duplaId)
      candidate.classList.toggle("opacity-50", selected)
      candidate.classList.toggle("grayscale", selected)
      candidate.classList.toggle("cursor-not-allowed", selected)
      candidate.draggable = !selected
      candidate.setAttribute("aria-disabled", selected)
    })

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

  get activeHiddenInputs() {
    return this.hiddenInputTargets.filter((input) => !input.disabled)
  }

  get activeSlots() {
    return this.slotTargets.filter((slot) => !slot.closest("[data-knockout-builder-target='game']")?.classList.contains("hidden"))
  }

  candidateName(id) {
    return this.candidateTargets.find((candidate) => candidate.dataset.duplaId === id)?.dataset.duplaName || "Dupla selecionada"
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
