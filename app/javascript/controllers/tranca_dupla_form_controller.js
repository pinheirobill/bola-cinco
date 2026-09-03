import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "entitySelect",
    "participantOne",
    "participantTwo",
    "previewEntity",
    "previewName",
    "previewParticipants",
    "teamName"
  ]

  connect() {
    this.autoFillName = this.teamNameValue().length === 0
    this.lastGeneratedName = this.generatedName()
    this.sync()
  }

  sync(event) {
    if (event?.target === this.teamNameTarget) {
      const currentValue = this.teamNameValue()
      this.autoFillName = currentValue.length === 0 || currentValue === this.lastGeneratedName
    }

    this.syncTeamName()
    this.syncPreview()
  }

  syncTeamName() {
    const generatedName = this.generatedName()
    const currentValue = this.teamNameValue()
    const shouldAutoFill = this.autoFillName || currentValue.length === 0 || currentValue === this.lastGeneratedName

    if (shouldAutoFill) {
      this.teamNameTarget.value = generatedName
      this.autoFillName = true
    }

    this.lastGeneratedName = generatedName
  }

  syncPreview() {
    if (this.hasPreviewNameTarget) {
      const previewName = this.teamNameValue() || this.generatedName() || "Nome da dupla"
      this.previewNameTarget.textContent = previewName
    }

    if (this.hasPreviewParticipantsTarget) {
      const participants = [this.participantOneValue(), this.participantTwoValue()].filter(Boolean)
      this.previewParticipantsTarget.textContent = participants.length > 0 ? participants.join(" · ") : "Nome 1 · Nome 2"
    }

    if (this.hasPreviewEntityTarget) {
      this.previewEntityTarget.textContent = this.entityValue() || `Automática: ${this.generatedName() || "nome da dupla"}`
    }

  }

  generatedName() {
    const participants = [this.participantOneValue(), this.participantTwoValue()].filter(Boolean)
    return participants.join(" / ")
  }

  teamNameValue() {
    return this.hasTeamNameTarget ? this.teamNameTarget.value.trim() : ""
  }

  participantOneValue() {
    return this.hasParticipantOneTarget ? this.participantOneTarget.value.trim() : ""
  }

  participantTwoValue() {
    return this.hasParticipantTwoTarget ? this.participantTwoTarget.value.trim() : ""
  }

  entityValue() {
    if (!this.hasEntitySelectTarget) return ""

    const option = this.entitySelectTarget.selectedOptions[0]
    if (!option) return ""

    return option.disabled ? "" : option.textContent.trim()
  }

}
