import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    document.getElementById("folder-modal").style.display = "flex";
  }

  close() {
    document.getElementById("folder-modal").style.display = "none";
  }
} 