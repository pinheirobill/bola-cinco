import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggleAll(event) {
    const group = event.currentTarget.closest("[data-tranca-duplas-group]")
    if (!group) return

    const checkboxes = Array.from(group.querySelectorAll('input[type="checkbox"][name="team_ids[]"]'))
    if (checkboxes.length === 0) return

    const shouldCheck = checkboxes.some((checkbox) => !checkbox.checked)
    checkboxes.forEach((checkbox) => {
      checkbox.checked = shouldCheck
      checkbox.dispatchEvent(new Event("change", { bubbles: true }))
    })
  }
}
