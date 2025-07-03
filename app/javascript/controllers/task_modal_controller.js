import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleTurboStream = this.handleTurboStream.bind(this);
    document.addEventListener('turbo:before-stream-render', this.handleTurboStream);
  }

  disconnect() {
    document.removeEventListener('turbo:before-stream-render', this.handleTurboStream);
  }

  open(event) {
    const listId = this.element.closest('[id^="list_"]').id.split('_')[1];
    document.getElementById(`task-modal-${listId}`).style.display = "flex";
  }

  close(event) {
    const listId = this.element.closest('[id^="list_"]').id.split('_')[1];
    document.getElementById(`task-modal-${listId}`).style.display = "none";
  }

  handleTurboStream(event) {
    // Limpa o formulário de tarefa após submit bem-sucedido
    const stream = event.target;
    if (stream.action === 'append' && stream.target.startsWith('tasks-in-list-')) {
      // Procura o formulário dentro do modal correspondente
      const listId = stream.target.replace('tasks-in-list-', '');
      const form = document.querySelector(`#task-modal-${listId} form`);
      if (form) form.reset();
    }
  }
} 