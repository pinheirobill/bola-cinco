import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.debug("[dialog] connect", this.element)
  }

  open(event) {
    const dialogId = event.currentTarget.dataset.dialogId
    const dialog = dialogId ? document.getElementById(dialogId) : null

    console.debug("[dialog] open", {
      trigger: event.currentTarget,
      dialogId,
      found: Boolean(dialog),
      open: dialog?.open
    })

    if (dialog && typeof dialog.showModal === "function") {
      dialog.showModal()
      console.debug("[dialog] opened", { dialogId, open: dialog.open })
      return
    }

    console.warn("[dialog] could not open dialog", { dialogId, dialog })
  }

  close(event) {
    const dialogId = event.currentTarget.dataset.dialogId
    const dialog = dialogId ? document.getElementById(dialogId) : null

    console.debug("[dialog] close", {
      trigger: event.currentTarget,
      dialogId,
      found: Boolean(dialog),
      open: dialog?.open
    })

    if (dialog && typeof dialog.close === "function") {
      dialog.close()
      console.debug("[dialog] closed", { dialogId, open: dialog.open })
      return
    }

    console.warn("[dialog] could not close dialog", { dialogId, dialog })
  }
}
