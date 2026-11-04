import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["primaryInput", "secondaryInput", "primarySwatch", "secondarySwatch", "primaryValue", "secondaryValue"]

  connect() {
    this.update()
  }

  update() {
    this.updateColor("primary")
    this.updateColor("secondary")
  }

  updateColor(color) {
    const value = this[`${color}InputTarget`].value.toUpperCase()
    this[`${color}SwatchTarget`].style.backgroundColor = value
    this[`${color}ValueTarget`].textContent = value
  }
}
