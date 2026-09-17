import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["group", "stageButton", "previous", "next", "counter"]

  connect() {
    this.showStage({ currentTarget: { dataset: { stage: "1" } } })
  }

  showStage(event) {
    this.stage = event.currentTarget.dataset.stage
    this.index = 0
    this.visibleGroups = this.groupTargets.filter((group) => group.dataset.stage === this.stage)
    this.renderCurrent()
    this.stageButtonTargets.forEach((button) => button.classList.toggle("btn-primary", button.dataset.stage === this.stage))
  }

  next() {
    if (!this.visibleGroups.length) return
    this.index = (this.index + 1) % this.visibleGroups.length
    this.renderCurrent()
  }

  previous() {
    if (!this.visibleGroups.length) return
    this.index = (this.index - 1 + this.visibleGroups.length) % this.visibleGroups.length
    this.renderCurrent()
  }

  renderCurrent() {
    this.groupTargets.forEach((group) => group.classList.toggle("hidden", !this.visibleGroups?.includes(group) || this.visibleGroups[this.index] !== group))
    const total = this.visibleGroups?.length || 0
    this.counterTarget.textContent = total ? `${this.index + 1} de ${total} chaves` : "Nenhuma chave"
    this.previousTarget.disabled = total <= 1
    this.nextTarget.disabled = total <= 1
  }
}
