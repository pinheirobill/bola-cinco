import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "search", "teamFilter", "visibleCount", "selectedCount"]

  connect() {
    if (this.hasTeamFilterTarget && this.teamFilterTarget.value) {
      this.syncTeamSelection()
    } else {
      this.refresh()
    }
  }

  filter() {
    const query = this.searchTarget.value.trim().toLowerCase()
    const teamFilter = this.hasTeamFilterTarget ? this.teamFilterTarget.value : ""

    this.itemTargets.forEach((item) => {
      const matchesQuery = query.length === 0 || item.dataset.searchIndex.includes(query)
      const matchesTeam = this.itemMatchesTeam(item, teamFilter)
      const matches = matchesQuery && matchesTeam
      item.classList.toggle("hidden", !matches)
    })

    this.refresh()
  }

  syncTeamSelection() {
    if (!this.hasTeamFilterTarget) {
      this.refresh()
      return
    }

    const teamFilter = this.teamFilterTarget.value

    this.filter()

    if (!teamFilter) {
      this.clearSelection()
      return
    }

    this.itemTargets.forEach((item) => {
      const input = this.inputFor(item)
      if (!input || input.disabled) return

      input.checked = this.itemMatchesTeam(item, teamFilter)
    })

    this.refresh()
  }

  refresh() {
    let visible = 0
    let selected = 0

    this.itemTargets.forEach((item) => {
      const input = this.inputFor(item)
      const isVisible = !item.classList.contains("hidden")
      const isSelected = input?.checked === true
      const selectedMark = item.querySelector("[data-athlete-picker-selected-mark]")

      if (isVisible) {
        visible += 1
      }

      if (isSelected) {
        selected += 1
      }

      item.classList.toggle("border-primary", isSelected)
      item.classList.toggle("ring-2", isSelected)
      item.classList.toggle("ring-primary/30", isSelected)
      item.classList.toggle("shadow-lg", isSelected)
      item.classList.toggle("bg-primary/10", isSelected)
      item.classList.toggle("opacity-70", input?.disabled)
      item.classList.toggle("bg-base-300", input?.disabled && !isSelected)

      if (selectedMark) {
        selectedMark.classList.toggle("opacity-0", !isSelected)
        selectedMark.classList.toggle("opacity-100", isSelected)
      }
    })

    if (this.hasVisibleCountTarget) {
      this.visibleCountTarget.textContent = visible
    }

    if (this.hasSelectedCountTarget) {
      this.selectedCountTarget.textContent = selected
    }
  }

  selectVisible() {
    this.itemTargets.forEach((item) => {
      if (item.classList.contains("hidden")) return

      const input = this.inputFor(item)
      if (input && !input.disabled) {
        input.checked = true
      }
    })

    this.refresh()
  }

  clearSelection() {
    this.itemTargets.forEach((item) => {
      const input = this.inputFor(item)
      if (input) input.checked = false
    })

    this.refresh()
  }

  inputFor(item) {
    return item.querySelector('input[type="checkbox"], input[type="radio"]')
  }

  itemMatchesTeam(item, teamId) {
    if (!teamId) return true

    const teamIds = (item.dataset.teamIds || item.dataset.teamId || "")
      .split(" ")
      .map((value) => value.trim())
      .filter(Boolean)

    return teamIds.includes(teamId)
  }
}
