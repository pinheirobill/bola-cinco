// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.BolaCinco ||= {}

async function copyTextToClipboard(value, sourceElement) {
  if (!value) return false

  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(value)
    } else {
      const textarea = document.createElement("textarea")
      textarea.value = value
      textarea.setAttribute("readonly", "")
      textarea.style.position = "fixed"
      textarea.style.opacity = "0"
      document.body.appendChild(textarea)
      textarea.select()

      const success = document.execCommand("copy")
      document.body.removeChild(textarea)

      if (!success) throw new Error("copy failed")
    }

    sourceElement?.dispatchEvent(
      new CustomEvent("clipboard:copied", {
        bubbles: true,
        detail: { message: "Link copiado" }
      })
    )
    return true
  } catch (_error) {
    sourceElement?.dispatchEvent(
      new CustomEvent("clipboard:copied", {
        bubbles: true,
        detail: { message: "Não foi possível copiar o link", variant: "error" }
      })
    )
    return false
  }
}

document.addEventListener("click", async (event) => {
  const button = event.target.closest("[data-copy-link='true']")
  if (!button) return

  event.preventDefault()
  await copyTextToClipboard(button.dataset.clipboardValue, button)
})

document.addEventListener("turbo:load", () => {
  const modalName = new URL(window.location.href).searchParams.get("modal")
  if (!modalName) return

  const modal = document.getElementById(`${modalName}-modal`)
  if (!modal || typeof modal.showModal !== "function" || modal.open) return

  modal.showModal()

  const url = new URL(window.location.href)
  url.searchParams.delete("modal")
  window.history.replaceState({}, "", url.toString())
})

window.BolaCinco.openCategoryDuplicateModal = (duplicateUrl, categoryName) => {
  const dialog = document.getElementById("duplicate-category-modal")
  const form = document.getElementById("duplicate-category-form")
  const nameInput = document.getElementById("duplicate-category-name")
  const sourceLabel = document.getElementById("duplicate-category-source")

  if (!dialog || !form || !nameInput) return

  form.action = duplicateUrl
  nameInput.value = categoryName || ""
  if (sourceLabel) {
    sourceLabel.textContent = categoryName || "categoria"
  }

  if (typeof dialog.showModal === "function" && !dialog.open) {
    dialog.showModal()
  }

  window.setTimeout(() => {
    nameInput.focus()
    nameInput.select()
  }, 0)
}

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

window.BolaCinco.toggleTrancaDuplas = (button) => {
  const group = button?.closest("[data-tranca-duplas-group]")
  console.debug("[invite-tranca-duplas] inline toggle", {
    hasButton: Boolean(button),
    hasGroup: Boolean(group)
  })

  if (!group) return

  const checkboxes = Array.from(group.querySelectorAll('input[type="checkbox"][name="team_ids[]"]'))
  console.debug("[invite-tranca-duplas] inline toggle group", {
    checkboxCount: checkboxes.length
  })

  if (checkboxes.length === 0) return

  const shouldCheck = checkboxes.some((checkbox) => !checkbox.checked)
  console.debug("[invite-tranca-duplas] inline toggle state", { shouldCheck })

  checkboxes.forEach((checkbox) => {
    console.debug("[invite-tranca-duplas] inline toggle checkbox", {
      name: checkbox.name,
      value: checkbox.value,
      checkedBefore: checkbox.checked,
      disabled: checkbox.disabled
    })
    checkbox.checked = shouldCheck
    checkbox.dispatchEvent(new Event("change", { bubbles: true }))
  })
}
