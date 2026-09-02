import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "groupCountField",
    "matchesPerOpponentField",
    "qualifiedField",
    "pointsFields",
    "tiebreakersField",
    "pointsSummary",
    "knockoutSummary",
    "groupKnockoutSummary",
    "optionCard"
  ]

  connect() {
    this.currentMode = null
    this.update()
  }

  chooseMode(event) {
    const mode = event.currentTarget.dataset.modeKey
    if (!mode) return
    const activeMode = this.currentMode || this.element.dataset.currentMode
    if (activeMode === mode) return

    this.currentMode = mode
    this.update()
  }

  update() {
    const mode = this.currentMode || this.element.dataset.currentMode
    if (!mode) return

    const isKnockoutOnly = mode === "mata_mata"
    const isGroupAndKnockout = mode === "grupos_mata_mata"
    const showScoringFields = !isKnockoutOnly
    const showGroupCountField = !isKnockoutOnly
    const showMatchesPerOpponentField = !isKnockoutOnly
    const showQualifiedField = isGroupAndKnockout
    const showTiebreakersField = !isKnockoutOnly

    if (this.hasGroupCountFieldTarget) this.applySectionState(this.groupCountFieldTarget, showGroupCountField)
    if (this.hasMatchesPerOpponentFieldTarget) this.applySectionState(this.matchesPerOpponentFieldTarget, showMatchesPerOpponentField)
    if (this.hasQualifiedFieldTarget) this.applySectionState(this.qualifiedFieldTarget, showQualifiedField)
    if (this.hasPointsFieldsTarget) this.applySectionState(this.pointsFieldsTarget, showScoringFields)
    if (this.hasTiebreakersFieldTarget) this.applySectionState(this.tiebreakersFieldTarget, showTiebreakersField)

    this.pointsSummaryTarget.classList.toggle("hidden", isKnockoutOnly)
    this.knockoutSummaryTarget.classList.toggle("hidden", !isKnockoutOnly)
    this.groupKnockoutSummaryTarget.classList.toggle("hidden", !isGroupAndKnockout)

    this.optionCardTargets.forEach((card) => {
      const active = card.dataset.modeKey === mode
      card.classList.toggle("border-primary", active)
      card.classList.toggle("bg-primary/5", active)
      card.classList.toggle("text-base-content", active)
      card.classList.toggle("border-base-300", !active)
      card.classList.toggle("bg-base-200", !active)
      card.classList.toggle("opacity-90", !active)
      card.classList.toggle("shadow-sm", active)
      card.setAttribute("aria-pressed", active ? "true" : "false")

      const selectedMark = card.querySelector("[data-selected-mark]")
      if (selectedMark) selectedMark.classList.toggle("hidden", !active)
    })
  }

  applySectionState(section, enabled) {
    section.classList.toggle("hidden", !enabled)

    section.querySelectorAll("input, select, textarea, button").forEach((element) => {
      if ("disabled" in element) {
        element.disabled = !enabled
      }
    })
  }
}
