import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stage", "button"]

  show(event) {
    const stage = event.currentTarget.dataset.stage
    this.stageTargets.forEach((element) => element.classList.toggle("hidden", element.dataset.stage !== stage))
    this.buttonTargets.forEach((button) => button.classList.toggle("btn-primary", button.dataset.stage === stage))
  }
}
