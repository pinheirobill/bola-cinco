// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import DialogController from "./dialog_controller"
import ClipboardController from "./clipboard_controller"
import FlashMessageController from "./flash_message_controller"

application.register("dialog", DialogController)
application.register("clipboard", ClipboardController)
application.register("flash-message", FlashMessageController)

eagerLoadControllersFrom("controllers", application)
