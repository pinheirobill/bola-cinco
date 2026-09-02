// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.BolaCinco ||= {}

window.BolaCinco.openMatchParticipationModal = (dialogId, teamId) => {
  const dialog = document.getElementById(dialogId)
  if (!dialog) return

  const search = dialog.querySelector('input[type="search"][data-athlete-picker-target="search"]')
  if (search) {
    search.value = ""
  }

  const teamFilters = dialog.querySelectorAll('select[name="match_participation[team_id]"], input[name="match_participation[team_id]"]')
  teamFilters.forEach((teamFilter) => {
    teamFilter.value = teamId || ""
    teamFilter.dispatchEvent(new Event("change", { bubbles: true }))
  })

  if (typeof dialog.showModal === "function") {
    if (!dialog.open) {
      dialog.showModal()
    }
    return
  }

  dialog.setAttribute("open", "")
}
