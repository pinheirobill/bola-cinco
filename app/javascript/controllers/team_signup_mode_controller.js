import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["existingSection", "newSection", "modeOption"]

  connect() {
    this.update()
  }

  update() {
    const mode = this.checkedMode()
    const showExisting = mode === "existing"

    if (this.hasExistingSectionTarget) {
      this.toggleSection(this.existingSectionTarget, showExisting)
    }

    if (this.hasNewSectionTarget) {
      this.toggleSection(this.newSectionTarget, !showExisting)
    }

    this.modeOptionTargets.forEach((option) => {
      const active = option.value === mode
      option.classList.toggle("border-primary", active)
      option.classList.toggle("bg-primary/10", active)
      option.classList.toggle("border-base-300", !active)
      option.classList.toggle("bg-base-100", !active)
    })
  }

  checkedMode() {
    return this.modeOptionTargets.find((option) => option.checked)?.value || "existing"
  }

  toggleSection(section, enabled) {
    section.classList.toggle("hidden", !enabled)
    section.querySelectorAll("input, select, textarea, button").forEach((element) => {
      if ("disabled" in element) {
        element.disabled = !enabled
      }
    })
  }
}
