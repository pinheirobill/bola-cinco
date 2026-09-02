import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    fieldName: String,
    itemLabel: {
      type: String,
      default: "Gol"
    },
    scoreSelector: String,
    fixedCount: {
      type: Number,
      default: 0
    }
  }

  static targets = ["fields", "minute"]

  connect() {
    this.boundScoreInputHandler = this.syncRows.bind(this)
    this.bindScoreInput()
    this.boundScorePollingHandler = this.pollScore.bind(this)
    this.lastObservedCount = this.desiredCount()
    if (this.hasScoreSelectorValue) {
      this.scorePollingInterval = window.setInterval(this.boundScorePollingHandler, 150)
    }
    this.syncRows()
  }

  disconnect() {
    this.unbindScoreInput()
    if (this.scorePollingInterval) window.clearInterval(this.scorePollingInterval)
  }

  refresh() {
    this.lastObservedCount = this.desiredCount()
    this.syncRows()
  }

  syncRows() {
    if (!this.hasFieldsTarget) return

    if (this.hasScoreSelectorValue) {
      return
    }

    if (this.hasFixedCountValue && this.fixedCountValue > 0) {
      this.ensureFixedRowCount(this.fixedCountValue)
      return
    }

    this.ensureTrailingBlankRow()
  }

  desiredCount() {
    const scoreInput = this.scoreInput
    if (!scoreInput) return this.fixedCountValue

    const scoreValue = Number.parseInt(scoreInput.value, 10)
    if (Number.isNaN(scoreValue) || scoreValue <= 0) return 1

    return scoreValue
  }

  pollScore() {
    const nextCount = this.desiredCount()
    if (nextCount === this.lastObservedCount) return

    this.lastObservedCount = nextCount
    this.syncRows()
  }

  bindScoreInput() {
    if (!this.hasScoreSelectorValue) return

    this.scoreInput = document.querySelector(this.scoreSelectorValue)
    if (!this.scoreInput) return

    this.scoreInput.addEventListener("input", this.boundScoreInputHandler)
    this.scoreInput.addEventListener("change", this.boundScoreInputHandler)
  }

  unbindScoreInput() {
    if (!this.scoreInput) return

    this.scoreInput.removeEventListener("input", this.boundScoreInputHandler)
    this.scoreInput.removeEventListener("change", this.boundScoreInputHandler)
  }

  ensureFixedRowCount(count = this.fixedCountValue) {
    while (this.minuteTargets.length > count) {
      const row = this.minuteTargets[this.minuteTargets.length - 1]?.closest("[data-minute-row]")
      if (row) row.remove()
      else break
    }

    while (this.minuteTargets.length < count) {
      this.fieldsTarget.appendChild(this.buildMinuteRow(this.minuteTargets.length, ""))
    }
  }

  ensureTrailingBlankRow() {
    if (this.minuteTargets.length === 0) {
      this.fieldsTarget.appendChild(this.buildMinuteRow(0, ""))
      return
    }

    const lastInput = this.minuteTargets[this.minuteTargets.length - 1]
    if (lastInput && lastInput.value.toString().trim() === "") return

    this.fieldsTarget.appendChild(this.buildMinuteRow(this.minuteTargets.length, ""))
  }

  buildMinuteRow(index, value) {
    const row = document.createElement("div")
    row.className = "flex items-center gap-2 rounded-xl bg-base-100 px-2 py-2"
    row.dataset.minuteRow = "true"

    const label = document.createElement("div")
    label.className = "shrink-0 text-xs font-semibold text-base-content/70"
    label.textContent = `${this.itemLabelValue} ${index + 1}`

    const input = document.createElement("input")
    input.type = "text"
    input.name = `${this.fieldNameValue}[]`
    input.value = value
    input.className = "input input-bordered input-sm min-w-0 flex-1"
    input.placeholder = "05"
    input.maxLength = 2
    input.inputMode = "numeric"
    input.autocomplete = "off"
    input.dataset.matchEventGoalsTarget = "minute"
    input.dataset.action = "input->match-event-goals#refresh"

    row.append(label, input)
    return row
  }
}
