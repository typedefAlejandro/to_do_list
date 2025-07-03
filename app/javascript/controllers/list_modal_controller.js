import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    // Encontra o modal correto pelo id do botão
    const folderId = this.element.closest('[id^="folder_"]').id.split('_')[1];
    document.getElementById(`list-modal-${folderId}`).style.display = "flex";
  }

  close(event) {
    const folderId = this.element.closest('[id^="folder_"]').id.split('_')[1];
    document.getElementById(`list-modal-${folderId}`).style.display = "none";
  }
} 