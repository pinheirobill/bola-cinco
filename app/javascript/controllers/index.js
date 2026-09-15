// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import DialogController from "controllers/dialog_controller"
import ClipboardController from "controllers/clipboard_controller"
import FlashMessageController from "controllers/flash_message_controller"
import KnockoutBuilderController from "controllers/knockout_builder_controller"

application.register("dialog", DialogController)
application.register("clipboard", ClipboardController)
application.register("flash-message", FlashMessageController)
application.register("knockout-builder", KnockoutBuilderController)

eagerLoadControllersFrom("controllers", application)
