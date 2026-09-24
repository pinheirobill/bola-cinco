import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["group", "stageButton"]

  connect() {
    this.showStage({ currentTarget: { dataset: { stage: "1" } } })
  }

  showStage(event) {
    this.stage = event.currentTarget.dataset.stage
    this.groupTargets.forEach((group) => {
      group.classList.toggle("hidden", group.dataset.stage !== this.stage)
    })

    this.stageButtonTargets.forEach((button) => button.classList.toggle("btn-primary", button.dataset.stage === this.stage))
  }
}
