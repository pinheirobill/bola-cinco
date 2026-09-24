import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stage", "button"]
  static values = { initialStage: String }

  show(event) {
    this.showStage(event.currentTarget.dataset.stage)
  }

  connect() {
    this.showStage(this.initialStageValue || "1")
  }

  showStage(stage) {
    const knockoutOnly = stage === "mata_mata"

    this.stageTargets.forEach((element) => {
      const matches = knockoutOnly ? element.dataset.phase === "mata_mata" : element.dataset.stage === stage
      element.classList.toggle("hidden", !matches)
    })
    this.buttonTargets.forEach((button) => button.classList.toggle("btn-primary", button.dataset.stage === stage))
  }
}
