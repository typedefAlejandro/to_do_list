// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import FolderModalController from "./folder_modal_controller"
import ListModalController from "./list_modal_controller"
import TaskModalController from "./task_modal_controller"
eagerLoadControllersFrom("controllers", application)
application.register("folder-modal", FolderModalController)
application.register("list-modal", ListModalController)
application.register("task-modal", TaskModalController)
